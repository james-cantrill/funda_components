

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Log in the master user';
	_output_json := (SELECT * FROM system_user_schema.action_user_login ('{"login": "muser", "password":"master"}'));
	RAISE NOTICE 'Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Result = %', (SELECT _output_json ->> 'message')::text;
END$$;

-- 	install system users

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'SET UP the user opal ';
	_output_json := (SELECT * FROM system_user_schema.action_add_new_user ('{"firstname": "Roger", "lastname": "Fitzroger", "login": "opal", "password":"spade", "changing_user_login": "muser"}'));
	RAISE NOTICE 'Result = %', (SELECT _output_json ->> 'result_indicator')::text;
END$$;

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'SET UP the user jappl';
	_output_json := (SELECT * FROM system_user_schema.action_add_new_user ('{"firstname": "John", "lastname": "Appleton", "login": "jappl", "password":"river", "changing_user_login": "muser"}'));
	RAISE NOTICE 'Result = %', (SELECT _output_json ->> 'result_indicator')::text;
END$$;

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'SET UP the user rwill';
	_output_json := (SELECT * FROM system_user_schema.action_add_new_user ('{"firstname": "Richard", "lastname": "Williams", "login": "rwill", "password":"road", "changing_user_login": "muser"}'));
	RAISE NOTICE 'Result = %', (SELECT _output_json ->> 'result_indicator')::text;
END$$;


DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Log out the master user';
	_output_json := (SELECT * FROM system_user_schema.action_user_logout ('{"login": "muser"}'));
	RAISE NOTICE 'Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Result = %', (SELECT _output_json ->> 'message')::text;
END$$;
