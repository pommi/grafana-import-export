# grafana-import-export

Simple scripts for import/export dashboards and datasources to [Grafana](http://grafana.org/)

Support organizations.

Example was taken from https://gist.github.com/crisidev/bd52bdcc7f029be2f295 

## Dependencies
**[JQ](https://stedolan.github.io/jq/)** - to process .json


Do not forget to set permissions before run
```
chmod 755 exporter.sh
```

Then run:
```
./exporter.sh HOST FILE_DIR USER PASSWORD
```

Expected output:
```
./exporter.sh
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 21102    0 21102    0     0  53000      0 --:--:-- --:--:-- --:--:-- 53020

```

Look for exported .json dashboards and datasources at **FILE_DIR** path

## importer
To make it work, you need to replace **HOST** and **FILE_DIR** variables with your own. And fill **ORGS** array with pairs ORGANIZATION:API_KEY

Do not forget to set permissions before run
```
chmod 755 importer.sh
```

To import all .json files from **FILE_DIR** to your Grafana:
```
./importer.sh HOST PATH_TO_EXPORT_FILES_FILE_DIR USER PASSWORD PATH_TO_DASHBOARD/*.json PATH_TO_DATASOURCE/*.json
```
