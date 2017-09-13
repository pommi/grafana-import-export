#!/usr/bin/env bash




if [ "$1" = "" ] || [ "$2" = "" ] || [ "$3" = "" ] || [ "$4" = "" ]; then
  echo $0: usage: $0  host file-dir username password
  exit
fi

HOST=$1
FILE_DIR=$2
USER=$3
PASSWORD=$4
DASHBOARD=$5
DATASOURCE=$6

ORGS=(
"MainOrg:xxxxxxxxxx")

import_file(){
	if ! [ -f "$1" ]
	then
	    echo "$file not found."
	    return
	fi

	printf "Processing $1 file...\n"
    curl -k -XPOST "http://${USER}:${PASSWORD}@${HOST}/api/$2" --data-binary @./$1 -H "Content-Type: application/json" -H "Accept: application/json"
    printf "\n"
}

if [[ -n $DASHBOARD ]]
then
	for f in "$@"; do
			IFS='/' read -r -a args <<< "$f"
			if ! [ ${#args[@]} == 3 ]
			then
					echo "Param $f. Skipping..."
					fi

		ARGORG=${args[0]}
		if [ -d "$FILE_DIR/$ARGORG" ]
		then
			for row in "${ORGS[@]}" ; do
				ORG=${row%%:*}
				if [ $ARGORG == $ORG ]
				then
					TYPE=${args[1]}
					FILE=${args[2]}

					for file in $FILE_DIR/$ORG/$TYPE/$FILE; do
							if [ $TYPE == 'dashboards' ]
							then
								import_file $file 'dashboards/db'
						else
								import_file $file 'datasources'
						fi
					done
				fi
			done
		else
			echo "$FILE_DIR/$ARGORG does not exist."
		fi
	done
	else
		printf "Importing all"
		for row in "${ORGS[@]}" ; do
		ORG=${row%%:*}
		DIR="$FILE_DIR/$ORG"

					printf "Datasources..."
					for file in $DIR/datasources/*.json; do
							import_file $file 'datasources'
					done

					printf "Dashboards..."
		for file in $DIR/dashboards/*.json; do
			import_file $file 'dashboards/db'
		done
	done

fi
