# setup-database.sh

echo 'please wait while database is starting up ...'

sleep 5s

echo 'try to connect to database in containder and create the sample db...'

/opt/mssql-tools/bin/sqlcmd -S localhost,1433 -U sa -P Wyf\&19971004 -d master -i ./sqlfiles/DBSchemaInit.sql

echo 'sample db have been created!'