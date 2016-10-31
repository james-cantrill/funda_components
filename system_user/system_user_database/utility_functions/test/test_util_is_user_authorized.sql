-- test_system_user_schema.util_is_user_authorized
--	test_util_is_user_authorized.sql

--	_in_data:	{
--					login:
--					service:
--					action:
--				}

--system				
SELECT * FROM system_user_schema.util_is_user_authorized ('{"login": "system", "service":"system_user", "action": "add_new_user"}');
				
-- unknown user
SELECT * FROM system_user_schema.util_is_user_authorized ('{"login": "wknows", "service":"system_user", "action": "add_new_user"}');

-- user not logged in
SELECT * FROM system_user_schema.action_user_logout ('{"login": "jappl"}'); -- make sure thbe ujser is logged loujt

SELECT * FROM system_user_schema.util_is_user_authorized ('{"login": "jappl", "service":"system_user", "action": "add_new_user"}');

-- user logged in
SELECT * FROM system_user_schema.action_user_login ('{"login": "opal", "password":"spade"}'); -- make sure the user is logged in

-- make sure user isn't authorized
SELECT * FROM system_user_schema.action_change_user_allowed_actions ('{"login": "opal", "service":"system_user", "action":"add_new_user", "task":"disallow"}');

-- test loged in and not authorized
SELECT * FROM system_user_schema.util_is_user_authorized ('{"login": "opal", "service":"system_user", "action": "add_new_user"}');

-- make sure user is authorized
SELECT * FROM system_user_schema.action_change_user_allowed_actions ('{"login": "opal", "service":"system_user", "action":"add_new_user", "task":"allow"}');

-- test loged in and authorized
SELECT * FROM system_user_schema.util_is_user_authorized ('{"login": "opal", "service":"system_user", "action": "add_new_user"}');

