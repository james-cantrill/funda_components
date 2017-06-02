/* the json object containng the inmput data, _in_data, is defined below.

	_in_data:	{
					firstname:
					lastname:
					login:
					password:
					changing_user_login:
				}
*/

-- Test 1 new user is added and can log in
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

	RAISE NOTICE 'TEST  new user John Appleton is added  expected result: Success';
	RAISE NOTICE '';
	_output_json := (SELECT * FROM system_user_schema.action_add_new_user ('{"firstname": "John", "lastname": "Appleton", "login": "jappl",  "password":"spade", "changing_user_login": "muser"}'));
	RAISE NOTICE 'Adding John Appleton result_indicator = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE '';
	RAISE NOTICE 'Add John Appleton _output_json = %', _output_json;
	
	_output_json := (SELECT * FROM system_user_schema.action_user_login ('{"login": "jappl", "password":"spade"}'));
	RAISE NOTICE 'TEST Login result_indicator = % ', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Login _output_json = %', _output_json;
	RAISE NOTICE '';
END$$;

/*
-- Test 2 changing user not authorized to load_run_selected_report
DO $$
DECLARE  
	_output_json	json;
BEGIN	
	RAISE NOTICE 'TEST  is John Appleton (jappl) isn''t authorized to add a new user expected result: Failure';
	_output_json := SELECT * FROM system_user_schema.action_add_new_user ('{"firstname": "Roger", "lastname": "Fitzroger",  "password":"spade", "changing_user_login": "jappl"}')::json;
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE '_output_json = %', _output_json;
	RAISE NOTICE '';
END$$;
*/

/*
--entering the first test using the login 'system' it should pass';
SELECT * FROM system_user_schema.action_add_new_user ('{"firstname": "Roger", "lastname": "Fitzroger",  "password":"spade", "changing_user_login": "muser"}');

--entering the first test using the login 'system' it should pass';
SELECT * FROM system_user_schema.action_add_new_user ('{"firstname": "Roger", "lastname": "Fitzroger", "login": "opal", "password":"spade", "changing_user_login": "muser"}');

--log in the new user
SELECT * FROM system_user_schema.action_user_login ('{"login": "opal", "password":"spade"}'); -- make sure the user is logged in

--test using 'opal' to add a user without authorization
-- make sure user isn't authorized
SELECT * FROM system_user_schema.action_change_user_allowed_actions ('{"login": "opal", "service":"system_user", "action":"add_new_user", "task":"disallow"}');
-- test loged in and not authorized
SELECT * FROM system_user_schema.action_add_new_user ('{"firstname": "John", "lastname": "Appleton", "login": "jappl", "password":"river", "changing_user_login": "opal"}');


-- now authborize the user opal
SELECT * FROM system_user_schema.action_change_user_allowed_actions ('{"login": "opal", "service":"system_user", "action":"add_new_user", "task":"allow"}');

--test using 'opal' to add a user after authorization
SELECT * FROM system_user_schema.action_add_new_user ('{"firstname": "John", "lastname": "Appleton", "login": "jappl", "password":"river", "changing_user_login": "opal"}');

--try adding another userwith the same login; it should fail';
SELECT * FROM system_user_schema.action_add_new_user ('{"firstname": "Roger", "lastname": "Fitzroger", "login": "opal", "password":"spade", "changing_user_login": "opal"}');

--other tests, first of each pair should fail, second succeed
SELECT * FROM system_user_schema.action_add_new_user ('{"firstname": "Jim", "lastname": "Doe", "login": "goper", "password":"douit", "changing_user_login": "supero"}');
SELECT * FROM system_user_schema.action_add_new_user ('{"firstname": "Jim", "lastname": "Doe", "login": "goper", "password":"douit", "changing_user_login": "opal"}');

SELECT * FROM system_user_schema.action_add_new_user ('{"firstname": "Milly", "lastname": "Kicks", "login": "mKicks", "password":"watch", "changing_user_login": "supero"}');
SELECT * FROM system_user_schema.action_add_new_user ('{"firstname": "Milly", "lastname": "Kicks", "login": "mKicks", "password":"watch", "changing_user_login": "opal"}');

*/
