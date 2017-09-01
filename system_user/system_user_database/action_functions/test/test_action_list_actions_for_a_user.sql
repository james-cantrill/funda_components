/* the json object containng the inmput data, _in_data, is defined below.

	_in_data:	{
					user_login:
					requesting_user_login:
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

	RAISE NOTICE 'TEST  list actions for John Appleton   expected result: Success';
	RAISE NOTICE '';
	_output_json := (SELECT * FROM system_user_schema.action_list_actions_for_a_user ('{"user_login": "jappl", "requesting_user_login": "muser"}'));
	RAISE NOTICE 'List actions for John Appleton _output_json = %', _output_json;
	RAISE NOTICE '';
	
	RAISE NOTICE 'TEST  list actions for Roger Miller rmiller (not in  system)  expected result: Failure';
	RAISE NOTICE '';
	_output_json := (SELECT * FROM system_user_schema.action_list_actions_for_a_user ('{"user_login": "rmiller", "requesting_user_login": "muser"}'));
	RAISE NOTICE 'List actions for Roger Miller _output_json = %', _output_json;
	RAISE NOTICE '';
	
	RAISE NOTICE 'TEST  list actions for John Doe requested by John Appleton (not authorized)  expected result: Failure';
	RAISE NOTICE '';
	_output_json := (SELECT * FROM system_user_schema.action_list_actions_for_a_user ('{"user_login": "jdoe", "requesting_user_login": "jappl"}'));
	RAISE NOTICE 'List actions requested by John Appleton _output_json = %', _output_json;
	RAISE NOTICE '';
	
END$$;


