
"C:\Program Files\PostgreSQL\9.4\bin\psql.exe" -h localhost -U postgres -d report_manager_database  -p 5432 -f ..\insert_parameters_in_parameter_list.sql 1> test_insert_parameters_in_parameter_list.log 2>&1 


"C:\Program Files\PostgreSQL\9.4\bin\psql.exe" -h localhost -U postgres -d report_manager_database  -p 5432 -f ..\run_insert_parameters_in_parameter_list.sql  1>> test_insert_parameters_in_parameter_list.log 2>>&1 

 
