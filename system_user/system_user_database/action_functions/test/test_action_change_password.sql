-- test_system_user_schema.action_change_password

-- the json object containng the inmput data, _in_data, is defined below.
--
--	_in_data:	{
--					login:
--					new_password:
--					changing_user_login:
--				}

-- calling user isn't logged in
DO $$
DECLARE  
	_output_json	json;
BEGIN	
	RAISE NOTICE 'TEST  Calling user is not loged in; expected result: Failure';
	RAISE NOTICE '';
	_output_json := (SELECT * FROM system_user_schema.action_change_password ('{"login": "opal", "new_password":"shovel", "changing_user_login":"muser"}'));
	RAISE NOTICE 'TEST Login result_indicator = % ', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;


-- calling user isn't authorized to change others password
DO $$
DECLARE  
	_output_json	json;
BEGIN	
	RAISE NOTICE 'TEST  Calling user is not authorized to change others password; expected result: Failure';
	RAISE NOTICE '';
	_output_json := (SELECT * FROM system_user_schema.action_user_login ('{"login": "opal", "password":"spade"}'));
	_output_json := (SELECT * FROM system_user_schema.action_change_password ('{"login": "jappl", "new_password":"creek", "changing_user_login":"opal"}'));
	RAISE NOTICE 'TEST Login result_indicator = % ', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
	_output_json := (SELECT * FROM system_user_schema.action_user_logout ('{"login": "opal"}'));
END$$;

--the user whose password is  being changed isn't in the system
DO $$
DECLARE  
	_output_json	json;
BEGIN	
	RAISE NOTICE 'TEST 3 User not in system; expected result: Failure';
	RAISE NOTICE '';
	_output_json := (SELECT * FROM system_user_schema.action_user_login ('{"login": "muser", "password":"master"}'));
	_output_json := (SELECT * FROM system_user_schema.action_change_password ('{"login": "myword", "new_password":"whoamI","changing_user_login":"muser"}'));
	RAISE NOTICE 'TEST Login result_indicator = % ', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
	_output_json := (SELECT * FROM system_user_schema.action_user_logout ('{"login": "muser"}'));
END$$;

-- Calling user changes login
DO $$
DECLARE  
	_output_json	json;
BEGIN	
	RAISE NOTICE 'TEST Calling user changes login; expected result: Success';
	RAISE NOTICE '';
	_output_json := (SELECT * FROM system_user_schema.action_user_login ('{"login": "muser", "password":"master"}'));
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	_output_json := (SELECT * FROM system_user_schema.action_change_password ('{"login": "opal", "new_password":"shovel", "changing_user_login":"muser"}'));
	RAISE NOTICE 'TEST Login result_indicator = % ', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
	_output_json := (SELECT * FROM system_user_schema.action_user_login ('{"login": "opal", "password":"spade"}'));
	RAISE NOTICE 'TEST Login result_indicator = % ', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
	_output_json := (SELECT * FROM system_user_schema.action_user_login ('{"login": "opal", "password":"shovel"}'));
	RAISE NOTICE 'TEST Login result_indicator = % ', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
	_output_json := (SELECT * FROM system_user_schema.action_user_logout ('{"login": "muser"}'));
	_output_json := (SELECT * FROM system_user_schema.action_user_logout ('{"login": "opal"}'));
END$$;
 


-- user changes their own password
DO $$
DECLARE  
	_output_json	json;
BEGIN	
	RAISE NOTICE 'TEST  Calling user changes their own password; expected result: Success';
	RAISE NOTICE '';
	_output_json := (SELECT * FROM system_user_schema.action_user_login ('{"login": "opal", "password":"shovel"}'));
	_output_json := (SELECT * FROM system_user_schema.action_change_password ('{"login": "opal", "new_password":"hoe", "changing_user_login":"opal"}'));
	RAISE NOTICE 'TEST Login result_indicator = % ', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
	_output_json := (SELECT * FROM system_user_schema.action_user_logout ('{"login": "opal"}'));
	_output_json := (SELECT * FROM system_user_schema.action_user_login ('{"login": "opal", "password":"hoe"}'));
	RAISE NOTICE 'TEST Login result_indicator = % ', (SELECT _output_json ->> 'result_indicator')::text;
	_output_json := (SELECT * FROM system_user_schema.action_user_logout ('{"login": "opal"}'));
END$$;
