/* the json object containng the inmput data, _in_data, is defined below.

	_in_data:	{
					firstname:
					lastname:
					login:
					password:
					changing_user_login:
				}
*/

DELETE  FROM system_user_schema.system_users;
DELETE  FROM system_user_schema.system_users_history;
DELETE  FROM system_user_schema.system_user_state;
DELETE  FROM system_user_schema.system_user_state_history;
DELETE  FROM system_user_schema.system_user_allowed_actions;
DELETE  FROM system_user_schema.system_user_allowed_actions_history;

--entering the first test using the login 'system' it should pass';
SELECT * FROM system_user_schema.action_add_new_user ('{"firstname": "Roger", "lastname": "Fitzroger", "login": "opal", "password":"spade", "changing_user_login": "muser"}');

--log in the new user
SELECT * FROM system_user_schema.action_user_login ('{"login": "opal", "password":"spade"}'); -- make sure the user is logged in

--test using 'opal' to add a user without authorization
-- make sure user isn't authorized
SELECT * FROM system_user_schema.action_change_user_allowed_actions ('{"login": "opal", "service":"system_user", "action":"add_new_user", "task":"disallow"}');
-- test loged in and not authorized
SELECT * FROM system_user_schema.action_add_new_user ('{"firstname": "John", "lastname": "Appleton", "login": "jappl", "password":"river", "changing_user_login": "opal"}');


-- now authborize the user opal
SELECT * FROM system_user_schema.action_change_user_allowed_actions ('{"login": "opal", "service":"system_user", "action":"add_new_user", "task":"allow"}');

--test using 'opal' to add a user after authorization
SELECT * FROM system_user_schema.action_add_new_user ('{"firstname": "John", "lastname": "Appleton", "login": "jappl", "password":"river", "changing_user_login": "opal"}');

--try adding another userwith the same login; it should fail';
SELECT * FROM system_user_schema.action_add_new_user ('{"firstname": "Roger", "lastname": "Fitzroger", "login": "opal", "password":"spade", "changing_user_login": "opal"}');

--other tests, first of each pair should fail, second succeed
SELECT * FROM system_user_schema.action_add_new_user ('{"firstname": "Jim", "lastname": "Doe", "login": "goper", "password":"douit", "changing_user_login": "supero"}');
SELECT * FROM system_user_schema.action_add_new_user ('{"firstname": "Jim", "lastname": "Doe", "login": "goper", "password":"douit", "changing_user_login": "opal"}');

SELECT * FROM system_user_schema.action_add_new_user ('{"firstname": "Milly", "lastname": "Kicks", "login": "mKicks", "password":"watch", "changing_user_login": "supero"}');
SELECT * FROM system_user_schema.action_add_new_user ('{"firstname": "Milly", "lastname": "Kicks", "login": "mKicks", "password":"watch", "changing_user_login": "opal"}');


