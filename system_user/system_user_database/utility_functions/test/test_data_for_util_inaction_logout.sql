-- test_system_user_schema.util_inaction_logout

DO $$
DECLARE  
	_output_json	json;
BEGIN	
	_output_json := (SELECT * FROM system_user_schema.action_user_login ('{"login": "opal", "password":"spade"}'));
	RAISE NOTICE 'TEST Roger Fitzroger Login result_indicator = % ', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';	
	PERFORM pg_sleep (60);
END$$;



DO $$
DECLARE  
	_output_json	json;
BEGIN	
	_output_json := (SELECT * FROM system_user_schema.action_user_login ('{"login": "jappl", "password":"river"}'));
	RAISE NOTICE 'TEST John Appleton Login result_indicator = % ', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';	
	PERFORM pg_sleep (30);
END$$;



DO $$
DECLARE  
	_output_json	json;
BEGIN	
	_output_json := (SELECT * FROM system_user_schema.action_user_login ('{"login": "rwill", "password":"road"}'));
	RAISE NOTICE 'TEST Richard Williams Login result_indicator = % ', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';	
END$$;

