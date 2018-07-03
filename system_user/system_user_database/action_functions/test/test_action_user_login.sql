-- system_user_schema.action_user_login

-- the json object containng the inmput data, _in_data, is defined below.
--	_in_data:	{
--					login:
--					password:
--				}

-- test 1 login is omitted
DO $$
DECLARE  
	_output_json	json;
BEGIN	
	RAISE NOTICE 'TEST 1 Login of user not in system; expected result: Failure';
	RAISE NOTICE '';
	_output_json := (SELECT * FROM system_user_schema.action_user_login ('{ "password":"whoamI"}'));
	RAISE NOTICE 'TEST Login result_indicator = % ', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;


-- test 2 user not in system
DO $$
DECLARE  
	_output_json	json;
BEGIN	
	RAISE NOTICE 'TEST 2 Login of user not in system; expected result: Failure';
	RAISE NOTICE '';
	_output_json := (SELECT * FROM system_user_schema.action_user_login ('{"login": "myword", "password":"whoamI"}'));
	RAISE NOTICE 'TEST Login result_indicator = % ', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

-- test 2 user in system wrong password
DO $$
DECLARE  
	_output_json	json;
BEGIN	
	RAISE NOTICE 'TEST 2 Login of user in system but with a wrong password; expected result: Failure';
	_output_json := (SELECT * FROM system_user_schema.action_user_login ('{"login": "jappl", "password":"whoamI"}'));
	RAISE NOTICE 'TEST John Appleton Login result_indicator = % ', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;


-- test 3 user in system, authorized, and right password 
DO $$
DECLARE  
	_output_json	json;
BEGIN	
	_output_json := (SELECT * FROM system_user_schema.action_user_login ('{"login": "opal", "password":"spade"}'));
	RAISE NOTICE 'TEST Roger Fitzroger Login result_indicator = % ', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
	
END$$;

-- test 4 user in system, authorized, and right password but user is already logged in
DO $$
DECLARE  
	_output_json	json;
BEGIN	
	_output_json := (SELECT * FROM system_user_schema.action_user_login ('{"login": "opal", "password":"spade"}'));
	RAISE NOTICE 'TEST Roger Fitzroger Login result_indicator = % ', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
	
END$$;

