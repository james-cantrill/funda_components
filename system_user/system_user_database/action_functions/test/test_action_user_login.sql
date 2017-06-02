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
	_output_json := (SELECT * FROM system_user_schema.action_user_login ('{"login": "muser", "password":"ha_melech!16"}'));
	RAISE NOTICE '';
	RAISE NOTICE 'Login muser _output_json = %', _output_json;
	RAISE NOTICE '';
END$$;

SELECT '';

-- test 1 user not in system
DO $$
DECLARE  
	_output_json	json;
BEGIN	
	RAISE NOTICE 'TEST 1 Login of user not in system; expected result: Failure';
	RAISE NOTICE '';
	_output_json := (SELECT * FROM system_user_schema.action_user_login ('{"login": "myword", "password":"whoamI"}'));
	RAISE NOTICE 'TEST Login result_indicator = % ', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Login _output_json = %', _output_json;
	RAISE NOTICE '';
END$$;

SELECT '';

-- test 2 user in system wrong password
DO $$
DECLARE  
	_output_json	json;
BEGIN	
	RAISE NOTICE 'TEST 2 Login of user in system but with a wrong password; expected result: Failure';
	RAISE NOTICE '';
	
	_output_json := (SELECT * FROM system_user_schema.action_add_new_user ('{"firstname": "John", "lastname": "Appleton", "login": "jappl",  "password":"spade", "changing_user_login": "muser"}'));
	RAISE NOTICE 'Adding John Appleton result_indicator = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE '';
	
	
	_output_json := (SELECT * FROM system_user_schema.action_user_login ('{"login": "jappl", "password":"whoamI"}'));
	RAISE NOTICE 'TEST John Appleton Login result_indicator = % ', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Login _output_json = %', _output_json;
	RAISE NOTICE '';
END$$;

SELECT '';


-- test 3 user in system, authorized, and right password
DO $$
DECLARE  
	_output_json	json;
BEGIN	
	RAISE NOTICE 'TEST 3 user in system, authorized, and right password; expected result: Success';
	RAISE NOTICE '';
	
	_output_json := (SELECT * FROM system_user_schema.action_add_new_user ('{"firstname": "Roger", "lastname": "Fitzroger", "login": "opal",  "password":"spade", "changing_user_login": "muser"}'));
	RAISE NOTICE 'Adding Roger Fitzroger result_indicator = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE '';
	RAISE NOTICE 'Add Roger Fitzroger _output_json = %', _output_json;
	
	_output_json := (SELECT * FROM system_user_schema.action_user_login ('{"login": "opal", "password":"spade"}'));
	RAISE NOTICE 'TEST Roger Fitzroger Login result_indicator = % ', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Login _output_json = %', _output_json;
	RAISE NOTICE '';
	
END$$;

SELECT '';


-- test 4 user in system, right password, but not authorized
DO $$
DECLARE  
	_output_json	json;
BEGIN	
	RAISE NOTICE 'TEST 4 user in system, right password, but not authorized; expected result: Failure';
	RAISE NOTICE '';
	
	_output_json := (SELECT * FROM system_user_schema.action_add_new_user ('{"firstname": "Milly", "lastname": "Kicks", "login": "mKicks", "password":"watch", "changing_user_login": "muser"}'));
	RAISE NOTICE 'Adding Milly Kicks result_indicator = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE '';
	RAISE NOTICE 'Add Milly Kicks _output_json = %', _output_json;
	
	_output_json := (SELECT * FROM system_user_schema.action_change_user_allowed_actions ('{"login": "mKicks", "service":"system_user", "action":"user_login", "task":"disallow", "changing_user_login": "muser"}'));
	RAISE NOTICE 'TEST change user allowed actions result_indicator = % ', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'change user allowed actions _output_json = %', _output_json;
	RAISE NOTICE '';
		
	_output_json := (SELECT * FROM system_user_schema.action_user_login ('{"login": "mKicks", "password":"watch"}'));
	RAISE NOTICE 'TEST Login result_indicator = % ', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Login _output_json = %', _output_json;
	RAISE NOTICE '';
	
END$$;

SELECT '';

/*
SELECT * FROM system_user_schema.action_user_login ('{"login": "opal", "password":"spade"}');

SELECT * FROM system_user_schema.action_user_login ('{"login": "opal65", "password":"spade"}');

SELECT * FROM system_user_schema.action_user_login ('{"login": "opal", "password":"carl34"}');
*/