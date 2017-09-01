
"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d system_user_demo_db  -p 5432 -f ..\action_list_actions_for_a_user.sql 1> test_action_list_actions_for_a_user.log 2>&1 

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d system_user_demo_db  -p 5432 -f test_action_list_actions_for_a_user.sql  1>> test_action_list_actions_for_a_user.log 2>>&1 

 