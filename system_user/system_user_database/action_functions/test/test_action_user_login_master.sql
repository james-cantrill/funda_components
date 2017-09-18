-- system_user_schema.action_user_login

-- the json object containng the inmput data, _in_data, is defined below.
--	_in_data:	{
--					login:
--					password:
--				}

-- prelminary preparation - 
DO $$
DECLARE  
	_output_json	json;
BEGIN	
	RAISE NOTICE 'TEST  Login master user  expected result: Success';
	RAISE NOTICE '';
	_output_json := (SELECT * FROM system_user_schema.action_user_login ('{"login": "muser", "password":"master"}'));
	RAISE NOTICE '';
	RAISE NOTICE 'Login muser _output_json = %', _output_json;
	RAISE NOTICE '';
END$$;

SELECT '';

