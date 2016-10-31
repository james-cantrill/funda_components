-- test_trig_log_user_history

-- the json object containng the inmput data, _in_data, is defined below.
--	_in_data:	{
--					login:
--					password:
--				}

-- clear all tables
DELETE  FROM system_user_schema.system_users;
DELETE  FROM system_user_schema.system_users_history;
DELETE  FROM system_user_schema.system_user_allowed_actions;

-- Create new users for test
SELECT * FROM system_user_schema.action_add_new_user ('{"firstname": "John", "lastname": "Doe", "login": "opal", "password":"carl", "changing_user_login": "supero"}');
SELECT * FROM system_user_schema.action_add_new_user ('{"firstname": "Roger", "lastname": "Fitzroger", "login": "gopal", "password":"spade", "changing_user_login": "supero"}');
SELECT * FROM system_user_schema.action_add_new_user ('{"firstname": "Jim", "lastname": "Doe", "login": "goper", "password":"douit", "changing_user_login": "supero"}');
SELECT * FROM system_user_schema.action_add_new_user ('{"firstname": "Milly", "lastname": "Kicks", "login": "mkicks", "password":"watch", "changing_user_login": "supero"}');
SELECT * FROM system_user_schema.action_add_new_user ('{"firstname": "John", "lastname": "Appleton", "login": "jappl", "password":"river", "changing_user_login": "supero"}');

SELECT 'All added';

SELECT pg_sleep (10);

UPDATE system_user_schema.system_users SET lastname = 'Williams' WHERE login = 'opal';
SELECT pg_sleep (10);
UPDATE system_user_schema.system_users SET lastname = 'Author' WHERE login = 'gopal';
SELECT pg_sleep (10);
UPDATE system_user_schema.system_users SET password = 'new_word' WHERE login = 'opal';
SELECT pg_sleep (10);

DELETE  FROM system_user_schema.system_users WHERE login = 'jappl';

SELECT * FROM system_user_schema.system_users;

SELECT ' ';

SELECT * FROM system_user_schema.system_users_history;