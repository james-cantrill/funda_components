-- test_system_user_schema.trig_log_state_history

-- the json object containng the inmput data, _in_data, is defined below.
--	_in_data:	{
--					login:
--					password:
--				}

-- clear all tables
DELETE  FROM system_user_schema.system_users;
DELETE  FROM system_user_schema.system_user_state;
DELETE  FROM system_user_schema.system_user_state_history;

-- Create new users for test
SELECT * FROM system_user_schema.action_add_new_user ('{"firstname": "John", "lastname": "Doe", "login": "opal", "password":"carl"}');
SELECT * FROM system_user_schema.action_add_new_user ('{"firstname": "Roger", "lastname": "Fitzroger", "login": "gopal", "password":"spade"}');
SELECT * FROM system_user_schema.action_add_new_user ('{"firstname": "Jim", "lastname": "Doe", "login": "goper", "password":"douit"}');
SELECT * FROM system_user_schema.action_add_new_user ('{"firstname": "Milly", "lastname": "Kicks", "login": "mkicks", "password":"watch"}');

SELECT pg_sleep (10);

-- log some in to fire the trigger
SELECT * FROM system_user_schema.action_user_login ('{"login": "opal", "password":"carl"}');
SELECT * FROM system_user_schema.action_user_login ('{"login": "gopal", "password":"spade"}');
SELECT * FROM system_user_schema.action_user_login ('{"login": "goper", "password":"douit"}');

-- show what happened
SELECT * FROM system_user_schema.system_user_state_history;

SELECT ' ';

SELECT * FROM system_user_schema.system_user_state;
