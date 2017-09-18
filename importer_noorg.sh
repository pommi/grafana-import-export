#/usr/bin/env bash

# This script will not iterate through orgs but imports the dashboards into the available org on grafana

set -e

if [ "$1" = "" ] || [ "$2" = "" ] || [ "$3" = "" ]; then
  echo $0: usage: $0  host directory
  exit
fi

HOST=$1
USER=admin
PASSWORD=$2
DIR=$3

import_file(){
        if ! [ -f "$1" ]
        then
            echo "$file not found."
            return
        fi

        if grep '{"dashboard":' $1 > /dev/null
        then
           echo "text exists"
        else
           echo '{"dashboard":' | cat - $1 > temp && mv temp $1

        fi

        if grep ',"overwrite": true}' $1 > /dev/null
        then
           echo "text exists"
        else
           echo ',"overwrite": true}' >> $1

        fi

        if grep "${DS_PROMETHEUS}" $1 > /dev/null
        then
           sed -i 's/${DS_PROMETHEUS}/prometheus/g' $1
        else
           echo "processing"

        fi

    curl -k -XPOST "http://${USER}:${PASSWORD}@${HOST}/api/dashboards/db" --data-binary @./$1 -H "Content-Type: application/json" -H "Accept: application/json"
    printf "\n"
}

printf "Dashboards..."
        for file in $DIR/*.json; do
                import_file $file
        done

