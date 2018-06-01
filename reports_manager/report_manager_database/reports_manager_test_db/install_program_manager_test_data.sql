

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

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'insert Chances and Changes';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_organizations ('{"organization_name": "Chances and Changes", "organization_description": "",  "changing_user_login": "muser", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'insert Steuben County Department of Social Services';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_organizations ('{"organization_name": "Steuben County Department of Social Services", "organization_description": "",  "changing_user_login": "muser", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'insert Catholic Charities of Livingston County';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_organizations ('{"organization_name": "Catholic Charities of Livingston County", "organization_description": "",  "changing_user_login": "muser", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'insert Arbor Housing and Development';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_organizations ('{"organization_name": "Arbor Housing and Development", "organization_description": "",  "changing_user_login": "muser", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'insert Catholic Charities of Steuben County';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_organizations ('{"organization_name": "Catholic Charities of Steuben County", "organization_description": "",  "changing_user_login": "muser", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'insert Livingston County DSS';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_organizations ('{"organization_name": "Livingston County DSS", "organization_description": "",  "changing_user_login": "muser", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'insert Catholic Charities of Tompkins/Tioga';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_organizations ('{"organization_name": "Catholic Charities of Tompkins/Tioga", "organization_description": "",  "changing_user_login": "muser", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'insert Chautauqua Opportunities';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_organizations ('{"organization_name": "Chautauqua Opportunities", "organization_description": "",  "changing_user_login": "muser", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

--****************************************************************************
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
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_programs ('{"program_name": "CCST Homeless Supportive Housing - HUD Permanent", "program_description": "", "other_program_id": "50008000", "organization_name":"Catholic Charities of Chemung and Schuyler Counties", "containing_level_name": "", "changed_by_user_login": "muser", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Insert CCST Homeless Supportive Housing Expansion';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_programs ('{"program_name": "CCST Homeless Supportive Housing Expansion", "program_description": "", "other_program_id": "50036000", "organization_name":"Catholic Charities of Chemung and Schuyler Counties", "containing_level_name": "", "changed_by_user_login": "muser", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Insert CCST NY083 Bonus Homeless Supportive Housing';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_programs ('{"program_name": "CCST NY083 Bonus Homeless Supportive Housing", "program_description": "", "other_program_id": "50043000", "organization_name":"Catholic Charities of Chemung and Schuyler Counties", "containing_level_name": "", "changed_by_user_login": "muser", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Insert CCST Rapid Re-housing Chemung SHARE';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_programs ('{"program_name": "CCST Rapid Re-housing Chemung SHARE", "program_description": "", "other_program_id": "70014008", "organization_name":"Catholic Charities of Chemung and Schuyler Counties", "containing_level_name": "", "changed_by_user_login": "muser", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Insert CCST Rapid Re-housing Schuyler SHARE';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_programs ('{"program_name": "CCST Rapid Re-housing Schuyler SHARE", "program_description": "", "other_program_id": "70014007", "organization_name":"Catholic Charities of Chemung and Schuyler Counties", "containing_level_name": "", "changed_by_user_login": "muser", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Insert CCST Shelter Plus Care - HUD Permanent';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_programs ('{"program_name": "CCST Shelter Plus Care - HUD Permanent", "program_description": "", "other_program_id": "50009000", "organization_name":"Catholic Charities of Chemung and Schuyler Counties", "containing_level_name": "", "changed_by_user_login": "muser", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Insert CCST SHP Permanent Housing P1 Schuyler';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_programs ('{"program_name": "CCST SHP Permanent Housing P1 Schuyler", "program_description": "", "other_program_id": "50034000", "organization_name":"Catholic Charities of Chemung and Schuyler Counties", "containing_level_name": "", "changed_by_user_login": "muser", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Insert CCST STEHP ESG Prevention';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_programs ('{"program_name": "CCST STEHP ESG Prevention", "program_description": "", "other_program_id": "10005000", "organization_name":"Catholic Charities of Chemung and Schuyler Counties", "containing_level_name": "", "changed_by_user_login": "muser", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Insert CCST STEHP ESG Re-Housing';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_programs ('{"program_name": "CCST STEHP ESG Re-Housing", "program_description": "", "other_program_id": "10006000", "organization_name":"Catholic Charities of Chemung and Schuyler Counties", "containing_level_name": "", "changed_by_user_login": "muser", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Insert CandC Jemison House';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_programs ('{"program_name": "CandC Jemison House", "program_description": "", "other_program_id": "40029000", "organization_name":"Chances and Changes", "containing_level_name": "", "changed_by_user_login": "muser", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Insert CandC SHP Permanent Housing';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_programs ('{"program_name": "CandC SHP Permanent Housing", "program_description": "", "other_program_id": "50042000", "organization_name":"Chances and Changes", "containing_level_name": "", "changed_by_user_login": "muser", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Insert CandC STEHP ESG Prevention';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_programs ('{"program_name": "CandC STEHP ESG Prevention", "program_description": "", "other_program_id": "10010000", "organization_name":"Chances and Changes", "containing_level_name": "", "changed_by_user_login": "muser", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Insert CandC STEHP ESG Re-Housing';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_programs ('{"program_name": "CandC STEHP ESG Re-Housing", "program_description": "", "other_program_id": "10011000", "organization_name":"Chances and Changes", "containing_level_name": "", "changed_by_user_login": "muser", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Insert Steuben DSS STEHP ESG Prevention';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_programs ('{"program_name": "Steuben DSS STEHP ESG Prevention", "program_description": "", "other_program_id": "10003000", "organization_name":"Steuben County Department of Social Services", "containing_level_name": "", "changed_by_user_login": "muser", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Insert Steuben DSS STEHP ESG Re-Housing';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_programs ('{"program_name": "Steuben DSS STEHP ESG Re-Housing", "program_description": "", "other_program_id": "10004000", "organization_name":"Steuben County Department of Social Services", "containing_level_name": "", "changed_by_user_login": "muser", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

-- ***************************************************************************
-- 3. Allow users to see organizations

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Make ACCORD Kalthoff House visible to muser';
	_output_json := (SELECT * FROM programs_manager_schema.action_change_program_user_visibility ('{"target_login": "muser", "program":"ACCORD Kalthoff House", "visible":"TRUE", "changing_user_login": "muser"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;		

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Make ACCORD Rapid Re-Housing Program 1 visible to muser';
	_output_json := (SELECT * FROM programs_manager_schema.action_change_program_user_visibility ('{"target_login": "muser", "program":"ACCORD Rapid Re-Housing Program 1", "visible":"TRUE", "changing_user_login": "muser"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;		

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Make ACCORD Rapid Re-Housing Program 2 visible to muser';
	_output_json := (SELECT * FROM programs_manager_schema.action_change_program_user_visibility ('{"target_login": "muser", "program":"ACCORD Rapid Re-Housing Program 2", "visible":"TRUE", "changing_user_login": "muser"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;		

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Make CCST Emergency Services Homeless Shelter visible to muser';
	_output_json := (SELECT * FROM programs_manager_schema.action_change_program_user_visibility ('{"target_login": "muser", "program":"CCST Emergency Services Homeless Shelter", "visible":"TRUE", "changing_user_login": "muser"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;		

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Make CCST Homeless Supportive Housing - HUD Permanent visible to muser';
	_output_json := (SELECT * FROM programs_manager_schema.action_change_program_user_visibility ('{"target_login": "muser", "program":"CCST Homeless Supportive Housing - HUD Permanent", "visible":"TRUE", "changing_user_login": "muser"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;		

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Make CCST Homeless Supportive Housing Expansion visible to muser';
	_output_json := (SELECT * FROM programs_manager_schema.action_change_program_user_visibility ('{"target_login": "muser", "program":"CCST Homeless Supportive Housing Expansion", "visible":"TRUE", "changing_user_login": "muser"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;		

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Make CCST NY083 Bonus Homeless Supportive Housing visible to muser';
	_output_json := (SELECT * FROM programs_manager_schema.action_change_program_user_visibility ('{"target_login": "muser", "program":"CCST NY083 Bonus Homeless Supportive Housing", "visible":"TRUE", "changing_user_login": "muser"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;		

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Make CCST Rapid Re-housing Chemung SHARE visible to muser';
	_output_json := (SELECT * FROM programs_manager_schema.action_change_program_user_visibility ('{"target_login": "muser", "program":"CCST Rapid Re-housing Chemung SHARE", "visible":"TRUE", "changing_user_login": "muser"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;		

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Make CCST Rapid Re-housing Schuyler SHARE visible to muser';
	_output_json := (SELECT * FROM programs_manager_schema.action_change_program_user_visibility ('{"target_login": "muser", "program":"CCST Rapid Re-housing Schuyler SHARE", "visible":"TRUE", "changing_user_login": "muser"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;		

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Make CCST Shelter Plus Care - HUD Permanent visible to muser';
	_output_json := (SELECT * FROM programs_manager_schema.action_change_program_user_visibility ('{"target_login": "muser", "program":"CCST Shelter Plus Care - HUD Permanent", "visible":"TRUE", "changing_user_login": "muser"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;		

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Make CCST SHP Permanent Housing P1 Schuyler visible to muser';
	_output_json := (SELECT * FROM programs_manager_schema.action_change_program_user_visibility ('{"target_login": "muser", "program":"CCST SHP Permanent Housing P1 Schuyler", "visible":"TRUE", "changing_user_login": "muser"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;		

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Make CCST STEHP ESG Prevention visible to muser';
	_output_json := (SELECT * FROM programs_manager_schema.action_change_program_user_visibility ('{"target_login": "muser", "program":"CCST STEHP ESG Prevention", "visible":"TRUE", "changing_user_login": "muser"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;		

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Make CCST STEHP ESG Re-Housing visible to muser';
	_output_json := (SELECT * FROM programs_manager_schema.action_change_program_user_visibility ('{"target_login": "muser", "program":"CCST STEHP ESG Re-Housing", "visible":"TRUE", "changing_user_login": "muser"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;		

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Make CandC Jemison House visible to muser';
	_output_json := (SELECT * FROM programs_manager_schema.action_change_program_user_visibility ('{"target_login": "muser", "program":"CandC Jemison House", "visible":"TRUE", "changing_user_login": "muser"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;		

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Make CandC SHP Permanent Housing visible to muser';
	_output_json := (SELECT * FROM programs_manager_schema.action_change_program_user_visibility ('{"target_login": "muser", "program":"CandC SHP Permanent Housing", "visible":"TRUE", "changing_user_login": "muser"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;		

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Make CandC STEHP ESG Prevention visible to muser';
	_output_json := (SELECT * FROM programs_manager_schema.action_change_program_user_visibility ('{"target_login": "muser", "program":"CandC STEHP ESG Prevention", "visible":"TRUE", "changing_user_login": "muser"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;		

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Make CandC STEHP ESG Re-Housing visible to muser';
	_output_json := (SELECT * FROM programs_manager_schema.action_change_program_user_visibility ('{"target_login": "muser", "program":"CandC STEHP ESG Re-Housing", "visible":"TRUE", "changing_user_login": "muser"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;		

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Make Steuben DSS STEHP ESG Prevention visible to muser';
	_output_json := (SELECT * FROM programs_manager_schema.action_change_program_user_visibility ('{"target_login": "muser", "program":"Steuben DSS STEHP ESG Prevention", "visible":"TRUE", "changing_user_login": "muser"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;		

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Make Steuben DSS STEHP ESG Re-Housing visible to muser';
	_output_json := (SELECT * FROM programs_manager_schema.action_change_program_user_visibility ('{"target_login": "muser", "program":"Steuben DSS STEHP ESG Re-Housing", "visible":"TRUE", "changing_user_login": "muser"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;		

-- ***************************************************************************
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Make CCST Emergency Services Homeless Shelter visible to opal';
	_output_json := (SELECT * FROM programs_manager_schema.action_change_program_user_visibility ('{"target_login": "opal", "program":"CCST Emergency Services Homeless Shelter", "visible":"TRUE", "changing_user_login": "muser"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;		

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Make CCST Homeless Supportive Housing - HUD Permanent visible to opal';
	_output_json := (SELECT * FROM programs_manager_schema.action_change_program_user_visibility ('{"target_login": "opal", "program":"CCST Homeless Supportive Housing - HUD Permanent", "visible":"TRUE", "changing_user_login": "muser"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;		

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Make CCST Homeless Supportive Housing Expansion visible to opal';
	_output_json := (SELECT * FROM programs_manager_schema.action_change_program_user_visibility ('{"target_login": "opal", "program":"CCST Homeless Supportive Housing Expansion", "visible":"TRUE", "changing_user_login": "muser"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;		

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Make CCST NY083 Bonus Homeless Supportive Housing visible to opal';
	_output_json := (SELECT * FROM programs_manager_schema.action_change_program_user_visibility ('{"target_login": "opal", "program":"CCST NY083 Bonus Homeless Supportive Housing", "visible":"TRUE", "changing_user_login": "muser"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;		

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Make CCST Rapid Re-housing Chemung SHARE visible to opal';
	_output_json := (SELECT * FROM programs_manager_schema.action_change_program_user_visibility ('{"target_login": "opal", "program":"CCST Rapid Re-housing Chemung SHARE", "visible":"TRUE", "changing_user_login": "muser"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;		

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Make CCST Rapid Re-housing Schuyler SHARE visible to opal';
	_output_json := (SELECT * FROM programs_manager_schema.action_change_program_user_visibility ('{"target_login": "opal", "program":"CCST Rapid Re-housing Schuyler SHARE", "visible":"TRUE", "changing_user_login": "muser"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;		

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Make CCST Shelter Plus Care - HUD Permanent visible to opal';
	_output_json := (SELECT * FROM programs_manager_schema.action_change_program_user_visibility ('{"target_login": "opal", "program":"CCST Shelter Plus Care - HUD Permanent", "visible":"TRUE", "changing_user_login": "muser"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;		

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Make CCST SHP Permanent Housing P1 Schuyler visible to opal';
	_output_json := (SELECT * FROM programs_manager_schema.action_change_program_user_visibility ('{"target_login": "opal", "program":"CCST SHP Permanent Housing P1 Schuyler", "visible":"TRUE", "changing_user_login": "muser"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;		

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Make CCST STEHP ESG Prevention visible to opal';
	_output_json := (SELECT * FROM programs_manager_schema.action_change_program_user_visibility ('{"target_login": "opal", "program":"CCST STEHP ESG Prevention", "visible":"TRUE", "changing_user_login": "muser"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;		

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Make CCST STEHP ESG Re-Housing visible to opal';
	_output_json := (SELECT * FROM programs_manager_schema.action_change_program_user_visibility ('{"target_login": "opal", "program":"CCST STEHP ESG Re-Housing", "visible":"TRUE", "changing_user_login": "muser"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;		

-- ***************************************************************************

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Make ACCORD Kalthoff House visible to jappl';
	_output_json := (SELECT * FROM programs_manager_schema.action_change_program_user_visibility ('{"target_login": "jappl", "program":"ACCORD Kalthoff House", "visible":"TRUE", "changing_user_login": "muser"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;		

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Make ACCORD Rapid Re-Housing Program 1 visible to jappl';
	_output_json := (SELECT * FROM programs_manager_schema.action_change_program_user_visibility ('{"target_login": "jappl", "program":"ACCORD Rapid Re-Housing Program 1", "visible":"TRUE", "changing_user_login": "muser"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;		

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Make ACCORD Rapid Re-Housing Program 2 visible to jappl';
	_output_json := (SELECT * FROM programs_manager_schema.action_change_program_user_visibility ('{"target_login": "jappl", "program":"ACCORD Rapid Re-Housing Program 2", "visible":"TRUE", "changing_user_login": "muser"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;		

-- ***************************************************************************
-- 4. allow users to list programs

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Allow user - opal - to list programs';
	_output_json := (SELECT * FROM system_user_schema.action_change_user_allowed_actions ('{"login": "opal", "service":"programs_manager", "action":"list_user_visible_programs", "task":"allow", "changing_user_login": "muser"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;		

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Allow user - json - to list programs';
	_output_json := (SELECT * FROM system_user_schema.action_change_user_allowed_actions ('{"login": "jappl", "service":"programs_manager", "action":"list_user_visible_programs", "task":"allow", "changing_user_login": "muser"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;		

