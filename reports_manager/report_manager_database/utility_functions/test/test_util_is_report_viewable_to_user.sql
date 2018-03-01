--  test_util_is_report_viewable_to_user.sql

-- 	_in_data:	{
-- 					login:
-- 					report_id:
-- 				}
-- 				
-- 	_out_json:	{
-- 					result_indicator:
-- 					message:
-- 					login:
-- 					report_id:
--					report_name:
-- 					authorized:
-- 				}				

-- Test 1 successful report viewable
DO $$
DECLARE  
	_output_json	json;
	_report_id	text;
BEGIN	
	RAISE NOTICE 'TEST 1 is Roger Fitzroger (opal) allowed to view CCST Managment Summary Monthly Report expected result: Success';
	_report_id :=	(SELECT
						report_id::text
					FROM	report_manager_schema.reports
					WHERE	report_name = 'CCST Managment Summary Monthly Report'
					);
	_output_json := (SELECT * FROM report_manager_schema.util_is_report_viewable_to_user (('{"login": "opal", "report_id": "' || _report_id || '"}')::json));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE '_output_json = %', _output_json;
	RAISE NOTICE '';
END$$;

-- Test 2 report NOT viewable
DO $$
DECLARE  
	_output_json	json;
	_report_id	text;
BEGIN	
	RAISE NOTICE 'TEST 2 is Roger Fitzroger (opal) allowed to view Gateways Openings - Schuyler Programs expected result: Failure';
	_report_id :=	(SELECT
						report_id::text
					FROM	report_manager_schema.reports
					WHERE	report_name = 'Gateways Openings - Schuyler Programs'
					);
	_output_json := (SELECT * FROM report_manager_schema.util_is_report_viewable_to_user (('{"login": "opal", "report_id": "' || _report_id || '"}')::json));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE '_output_json = %', _output_json;
	RAISE NOTICE '';
END$$;

-- Test 3 report doesn't exist
DO $$
DECLARE  
	_output_json	json;
	_report_id	text;
BEGIN	
	RAISE NOTICE 'TEST 3 is Roger Fitzroger (opal) allowed to view A Non-existent Report expected result: Non-existent';
	_report_id :=	(SELECT
						report_id::text
					FROM	report_manager_schema.reports
					WHERE	report_name = 'A Non-existent Report'
					);
	_output_json := (SELECT * FROM report_manager_schema.util_is_report_viewable_to_user (('{"login": "opal", "report_id": "' || _report_id || '"}')::json));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE '_output_json = %', _output_json;
	RAISE NOTICE '';
END$$;


