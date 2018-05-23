

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Log in the master user';
	_output_json := (SELECT * FROM system_user_schema.action_user_login ('{"login": "muser", "password":"master"}'));
	RAISE NOTICE 'Result = %', (SELECT _output_json ->> 'result_indicator')::text;
END$$;

-- 1.	Install organizations

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'insert ACCORD Corporation';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_organizations ('{"organization_name": "ACCORD Corporation", "organization_description": "",  "changing_user_login": "muser", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'insert Catholic Charities of Chemung and Schuyler Counties';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_organizations ('{"organization_name": "Catholic Charities of Chemung and Schuyler Counties", "organization_description": "",  "changing_user_login": "muser", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

-- 2. Install programs

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Insert ACCORD Kalthoff House';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_programs ('{"program_name": "ACCORD Kalthoff House", "program_description": "", "other_program_id": "40028000", "organization_name":"ACCORD Corporation", "containing_level_name": "", "changed_by_user_login": "muser", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Insert ACCORD Rapid Re-Housing Program 1';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_programs ('{"program_name": "ACCORD Rapid Re-Housing Program 1", "program_description": "", "other_program_id": "70014021", "organization_name":"ACCORD Corporation", "containing_level_name": "", "changed_by_user_login": "muser", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Insert ACCORD Rapid Re-Housing Program 2';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_programs ('{"program_name": "ACCORD Rapid Re-Housing Program 2", "program_description": "", "other_program_id": "70014022", "organization_name":"ACCORD Corporation", "containing_level_name": "", "changed_by_user_login": "muser", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Insert CCST Emergency Services Homeless Shelter';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_programs ('{"program_name": "CCST Emergency Services Homeless Shelter", "program_description": "", "other_program_id": "70008000", "organization_name":"Catholic Charities of Chemung and Schuyler Counties", "containing_level_name": "", "changed_by_user_login": "muser", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Insert CCST Homeless Supportive Housing - HUD Permanent';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_programs ('{"program_name": "CCST Homeless Supportive Housing - HUD Permanent", "program_description": "", "other_program_id": "70008000", "organization_name":"Catholic Charities of Chemung and Schuyler Counties", "containing_level_name": "", "changed_by_user_login": "muser", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;


