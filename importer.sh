#!/usr/bin/env bash

set -x 

USER=admin
PASSWORD=ir8isypsg7dynjekdu5z

HOST="172.28.106.6:3000"
FILE_DIR=${arg[0]}

import_file(){
	if ! [ -f "$1" ]
	then
	    echo "$file not found."
	    return
	fi

	printf "Processing $1 file...\n"
    curl -k -XPOST "http://${USER}:${PASSWORD}@${HOST}/api/$3" --data-binary @./$1 -H "Content-Type: application/json" -H "Accept: application/json"
    printf "\n"
}

if [[ -n "$1" ]]
	then
		for f in "$@"; do
		    IFS='/' read -r -a args <<< "$f"
		    if ! [ ${#args[@]} == 3 ]
		    then
		        echo "Wrong param $f. Must be `organization/type/file`"
            fi

    	printf "Importing all"

			DIR="$FILE_DIR"

            printf "Datasources..."
            for file in $DIR/datasources/*.json; do
                import_file $file $KEY 'datasources'
            done

            printf "Dashboards..."
			for file in $DIR/dashboards/*.json; do
				import_file $file $KEY 'dashboards/db'
			done
		done

fi
