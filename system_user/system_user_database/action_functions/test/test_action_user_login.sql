-- system_user_schema.action_user_login

-- the json object containng the inmput data, _in_data, is defined below.
--	_in_data:	{
--					login:
--					password:
--				}

SELECT * FROM system_user_schema.action_user_login ('{"login": "opal", "password":"spade"}');

SELECT * FROM system_user_schema.action_user_login ('{"login": "opal65", "password":"spade"}');

SELECT * FROM system_user_schema.action_user_login ('{"login": "opal", "password":"carl34"}');
