-- test_system_user_schema.action_change_user_allowed_actions

-- the json object containng the inmput data, _in_data, is defined below.
--
--	_in_data:	{
--					login:
--					service:
--					action:
--					task:
--					changing_user_login:
--				}
--			
--Code to be tested
--	authorized (logged in and and enter_edit_allowed_actions is allowed
--		and user is in the system
--			task = allow and action is not allowed
--			task = allow and action is allowed
--			task = disallow and action is allowed
--			task = disallow and action is not allowed--
--		and user is not in the system
--	authorized (logged in and and enter_edit_allowed_actions is not allowed
--	authorized (logged out and and enter_edit_allowed_actions is allowed
--	authorized (logged out and and enter_edit_allowed_actions is not allowed

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
SELECT * FROM system_user_schema.action_change_user_allowed_actions ('{"login": "opal", "service":"system_user", "action":"add_new_user", "task":"allow", "changing_user_login": "system"}');

-- add more users
SELECT * FROM system_user_schema.action_add_new_user ('{"firstname": "John", "lastname": "Appleton", "login": "jappl", "password":"river", "changing_user_login": "opal"}');
SELECT * FROM system_user_schema.action_add_new_user ('{"firstname": "Jim", "lastname": "Doe", "login": "goper", "password":"douit", "changing_user_login": "opal"}');
--***************************************************************************

--	authorized (logged in and and enter_edit_allowed_actions is not allowed
SELECT * FROM system_user_schema.action_change_user_allowed_actions ('{"login": "jappl", "service":"system_user", "action":"enter_edit_allowed_actions", "task":"allow", "changing_user_login": "opal"}');

--	authorized (logged in and and enter_edit_allowed_actions is allowed
--		and user is in the system
--			task = allow and action is not allowed
SELECT * FROM system_user_schema.action_change_user_allowed_actions ('{"login": "opal", "service":"system_user", "action":"enter_edit_allowed_actions", "task":"allow", "changing_user_login": "system"}');
SELECT * FROM system_user_schema.action_change_user_allowed_actions ('{"login": "jappl", "service":"system_user", "action":"change_password", "task":"allow", "changing_user_login": "opal"}');

--	authorized (logged in and and enter_edit_allowed_actions is allowed
--		and user is in the system
--			task = allow and action is allowed
SELECT * FROM system_user_schema.action_change_user_allowed_actions ('{"login": "jappl", "service":"system_user", "action":"change_password", "task":"allow", "changing_user_login": "opal"}');

--	authorized (logged in and and enter_edit_allowed_actions is allowed
--		and user is in the system
--			task = disallow and action is allowed
SELECT * FROM system_user_schema.action_change_user_allowed_actions ('{"login": "jappl", "service":"system_user", "action":"change_password", "task":"disallow", "changing_user_login": "opal"}');

--	authorized (logged in and and enter_edit_allowed_actions is allowed
--		and user is in the system
--			task = disallow and action is not allowed--
SELECT * FROM system_user_schema.action_change_user_allowed_actions ('{"login": "jappl", "service":"system_user", "action":"change_password", "task":"disallow", "changing_user_login": "opal"}');


--	authorized (logged in and and enter_edit_allowed_actions is allowed
--		and user is not in the system
SELECT * FROM system_user_schema.action_change_user_allowed_actions ('{"login": "wknows", "service":"system_user", "action":"change_password", "task":"disallow", "changing_user_login": "opal"}');

--	authorized (logged out and and enter_edit_allowed_actions is allowed
SELECT * FROM system_user_schema.action_user_logout ('{"login": "opal"}');
SELECT * FROM system_user_schema.action_change_user_allowed_actions ('{"login": "jappl", "service":"system_user", "action":"change_password", "task":"allow", "changing_user_login": "opal"}');

--	authorized (logged in and and enter_edit_allowed_actions is not allowed
SELECT * FROM system_user_schema.action_user_login ('{"login": "opal", "password":"spade"}'); -- make sure the user is logged in
SELECT * FROM system_user_schema.action_change_user_allowed_actions ('{"login": "opal", "service":"system_user", "action":"enter_edit_allowed_actions", "task":"disallow", "changing_user_login": "opal"}');
SELECT * FROM system_user_schema.action_change_user_allowed_actions ('{"login": "jappl", "service":"system_user", "action":"change_password", "task":"allow", "changing_user_login": "opal"}');


--	authorized (logged out and and enter_edit_allowed_actions is not allowed
SELECT * FROM system_user_schema.action_user_logout ('{"login": "opal"}');
SELECT * FROM system_user_schema.action_change_user_allowed_actions ('{"login": "jappl", "service":"system_user", "action":"change_password", "task":"allow", "changing_user_login": "opal"}');
