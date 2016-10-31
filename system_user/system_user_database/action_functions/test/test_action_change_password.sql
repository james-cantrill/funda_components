-- test_system_user_schema.action_change_password

-- the json object containng the inmput data, _in_data, is defined below.
--
--	_in_data:	{
--					login:
--					new_password:
--					changing_user_login:
--				}

--Set up the system
DELETE  FROM system_user_schema.system_users;
DELETE  FROM system_user_schema.system_users_history;
DELETE  FROM system_user_schema.system_user_state;
DELETE  FROM system_user_schema.system_user_state_history;
DELETE  FROM system_user_schema.system_user_allowed_actions;
DELETE  FROM system_user_schema.system_user_allowed_actions_history;

SELECT * FROM system_user_schema.action_add_new_user ('{"firstname": "Roger", "lastname": "Fitzroger", "login": "opal", "password":"spade", "changing_user_login": "system"}');
SELECT * FROM system_user_schema.util_get_user_state ('opal');
SELECT * FROM system_user_schema.action_user_login ('{"login": "opal", "password":"spade"}'); -- make sure the user is logged in
SELECT * FROM system_user_schema.util_get_user_state ('opal');
SELECT * FROM system_user_schema.action_change_user_allowed_actions ('{"login": "opal", "service":"system_user", "action":"add_new_user", "task":"allow"}');

-- add more users
SELECT * FROM system_user_schema.action_add_new_user ('{"firstname": "John", "lastname": "Appleton", "login": "jappl", "password":"river", "changing_user_login": "opal"}');
SELECT * FROM system_user_schema.action_add_new_user ('{"firstname": "Jim", "lastname": "Doe", "login": "goper", "password":"douit", "changing_user_login": "opal"}');

--**********************************************************

-- test a user changing their own password when logged out should fail
SELECT * FROM system_user_schema.action_user_logout ('{"login": "opal"}');
SELECT * FROM system_user_schema.util_get_user_state ('opal');
SELECT * FROM system_user_schema.action_change_password ('{"login": "opal", "new_password":"robert", "changing_user_login": "opal"}');

-- test a user changing their own password when logged in should pass
SELECT * FROM system_user_schema.action_user_login ('{"login": "opal", "password":"spade"}');
SELECT * FROM system_user_schema.action_change_password ('{"login": "opal", "new_password":"robert", "changing_user_login": "opal"}');

-- test a user trying to change another user's password withnout authorization should fail to change the password
-- make sure user isn't authorized
SELECT * FROM system_user_schema.action_change_user_allowed_actions ('{"login": "opal", "service":"system_user", "action":"change_password", "task":"disallow"}');
SELECT * FROM system_user_schema.action_change_password ('{"login": "goper",  "new_password": "geniu8s", "changing_user_login": "opal"}');

-- test a juser trying to change another user's password when they are authorized should change the password
-- make sure user is authorized
SELECT * FROM system_user_schema.action_change_user_allowed_actions ('{"login": "opal", "service":"system_user", "action":"change_password", "task":"allow"}');
SELECT * FROM system_user_schema.action_user_login ('{"login": "opal", "password":"robert"}'); -- make sure the user is logged in
SELECT * FROM system_user_schema.action_change_password ('{"login": "goper",  "new_password": "geniu8s", "changing_user_login": "opal"}');


--test changing password of a non-user should fail
SELECT * FROM system_user_schema.action_change_password ('{"login": "opal65",  "new_password": "robert", "changing_user_login": "opal"}');

