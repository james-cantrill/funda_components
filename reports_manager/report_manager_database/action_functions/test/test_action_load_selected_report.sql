-- test_action_load_selected_report.sql

--	_in_data:	{
--					login:
--					report_id:
--				}
			
--	_out_json:	{
--					result_indicator:
--					message:
--					report_name:
--					url:
--					parameters: [{
--								parameter_name:
--								parameter_type:
--								parameter_load_method:
--								parameter_description:
--					}]
--				};
SELECT * FROM system_user_schema.action_change_user_allowed_actions ('{"login": "opal", "service":"report_manager", "action":"load_run_selected_report", "task":"allow", "changing_user_login": "muser"}');
SELECT * FROM system_user_schema.action_change_user_allowed_actions ('{"login": "jappl", "service":"report_manager", "action":"load_run_selected_report", "task":"allow", "changing_user_login": "muser"}');

-- Test 1 successful report load
DO $$
DECLARE  
	_output_json	json;
	_report_id	text;
BEGIN	
	RAISE NOTICE 'TEST 1 is Roger Fitzroger (opal) loads CCST Managment Summary Monthly Report expected result: Success';
	_report_id :=	(SELECT
						report_id::text
					FROM	report_manager_schema.reports
					WHERE	report_name = 'CCST Managment Summary Monthly Report'
					);
	RAISE NOTICE 'TEST _report_id = %', _report_id;
	_output_json := (SELECT * FROM report_manager_schema.action_load_selected_report (('{"login": "opal", "report_id": "' || _report_id || '"}')::json));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE '_output_json = %', _output_json;
	RAISE NOTICE '';
END$$;

-- Test 2 user not authoried to load_run_selected_report
DO $$
DECLARE  
	_output_json	json;
	_report_id	text;
BEGIN	
	RAISE NOTICE 'TEST  is John Appleton (jappl) isn''t authorized to load  CCST Managment Summary Monthly Report expected result: Failure';
	_report_id :=	(SELECT
						report_id::text
					FROM	report_manager_schema.reports
					WHERE	report_name = 'CCST Managment Summary Monthly Report'
					);
	RAISE NOTICE 'TEST _report_id = %', _report_id;
	_output_json := (SELECT * FROM report_manager_schema.action_load_selected_report (('{"login": "jappl", "report_id": "' || _report_id || '"}')::json));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE '_output_json = %', _output_json;
	RAISE NOTICE '';
END$$;

-- Test 3 report isn't viewable to user
DO $$
DECLARE  
	_output_json	json;
	_report_id	text;
BEGIN	
	RAISE NOTICE 'TEST 3 is Roger Fitzroger (opal) allowed to view Gateways Openings - Schuyler Programs expected result: Failure';
	_report_id :=	(SELECT
						report_id::text
					FROM	report_manager_schema.reports
					WHERE	report_name = 'Gateways Openings - Schuyler Programs'
					);
	RAISE NOTICE 'TEST _report_id = %', _report_id;
	_output_json := (SELECT * FROM report_manager_schema.action_load_selected_report (('{"login": "opal", "report_id": "' || _report_id || '"}')::json));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE '_output_json = %', _output_json;
	RAISE NOTICE '';
END$$;

-- Test 4 report doesn't exist
DO $$
DECLARE  
	_output_json	json;
	_report_id	text;
BEGIN	
	RAISE NOTICE 'TEST 4 is Roger Fitzroger (opal) allowed to view A Non-existent Report expected result: Failure';
	_output_json := (SELECT * FROM report_manager_schema.action_load_selected_report (('{"login": "opal", "report_id": "425912cc-5662-4e80-86bd-fee50ba745ba"}')::json));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE '_output_json = %', _output_json;
	RAISE NOTICE '';
END$$;


-- Test 5 successful report load
DO $$
DECLARE  
	_output_json	json;
	_report_id	text;
BEGIN	
	RAISE NOTICE 'TEST 5 is Roger Fitzroger (opal) loads Demographics of People Served by the Selected Programs expected result: Success';
	_report_id :=	(SELECT
						report_id::text
					FROM	report_manager_schema.reports
					WHERE	report_name = 'Demographics of People Served by the Selected Programs'
					);
	RAISE NOTICE 'TEST _report_id = %', _report_id;
	_output_json := (SELECT * FROM report_manager_schema.action_load_selected_report (('{"login": "opal", "report_id": "' || _report_id || '"}')::json));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE '_output_json = %', _output_json;
	RAISE NOTICE '';
END$$;

-- Test 6 successful report load
DO $$
DECLARE  
	_output_json	json;
	_report_id	text;
BEGIN	
	RAISE NOTICE 'TEST 6 is Roger Fitzroger (opal) loads General Public Assistance and TANF Income of Adults Participating in the Selected Programs expected result: Success';
	_report_id :=	(SELECT
						report_id::text
					FROM	report_manager_schema.reports
					WHERE	report_name = 'General Public Assistance and TANF Income of Adults Participating in the Selected Programs'
					);
	RAISE NOTICE 'TEST _report_id = %', _report_id;
	_output_json := (SELECT * FROM report_manager_schema.action_load_selected_report (('{"login": "opal", "report_id": "' || _report_id || '"}')::json));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE '_output_json = %', _output_json;
	RAISE NOTICE '';
END$$;

-- Test 7 successful report load
DO $$
DECLARE  
	_output_json	json;
	_report_id	text;
BEGIN	
	RAISE NOTICE 'TEST 7 is Roger Fitzroger (opal) loads NY-501 Housing Summary Report expected result: Success';
	_report_id :=	(SELECT
						report_id::text
					FROM	report_manager_schema.reports
					WHERE	report_name = 'NY-501 Housing Summary Report'
					);
	RAISE NOTICE 'TEST _report_id = %', _report_id;
	_output_json := (SELECT * FROM report_manager_schema.action_load_selected_report (('{"login": "opal", "report_id": "' || _report_id || '"}')::json));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE '_output_json = %', _output_json;
	RAISE NOTICE '';
END$$;




