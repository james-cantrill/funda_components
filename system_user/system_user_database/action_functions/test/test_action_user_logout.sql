-- test_system_user_schema.action_user_logout

-- the json object containng the inmput data, _in_data, is defined below.
--	_in_data:	{
--					login:
--					password:
--				}

SELECT * FROM system_user_schema.action_user_logout ('{"login": "opal"}');

SELECT * FROM system_user_schema.action_user_logout ('{"login": "opal65"}');

SELECT * FROM system_user_schema.action_user_logout ('{"login": "opal"}');
