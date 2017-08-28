/* the json object containng the input data, _in_data, is defined below.

	_	_in_data:	{
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

	RAISE NOTICE 'TEST list users when only master is configured';
	RAISE NOTICE '';
	_output_json := (SELECT * FROM system_user_schema.action_list_users ('{"requesting_user_login": "muser"}'));
	RAISE NOTICE 'User List _output_json = %',  _output_json;
	RAISE NOTICE '';

END$$;


-- Test 2 addm so0me users then run list

DO $$
DECLARE  
	_output_json	json;
BEGIN	
	_output_json := (SELECT * FROM system_user_schema.action_add_new_user ('{"firstname": "Roger", "lastname": "Fitzroger",  "password":"spade", "changing_user_login": "muser"}'))::json;
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	_output_json := (SELECT * FROM system_user_schema.action_add_new_user ('{"firstname": "John", "lastname": "Appleton", "login": "jappl", "password":"river", "changing_user_login": "muser"}'))::json;
	RAISE NOTICE '';
	_output_json := (SELECT * FROM system_user_schema.action_list_users ('{"requesting_user_login": "muser"}'));
	RAISE NOTICE 'User List _output_json = %',  _output_json;
	RAISE NOTICE '';
END$$;


/*

--other tests, first of each pair should fail, second succeedSELECT * FROM system_user_schema.action_add_new_user ('{"firstname": "Jim", "lastname": "Doe", "login": "goper", "password":"douit", "changing_user_login": "supero"}');
SELECT * FROM system_user_schema.action_add_new_user ('{"firstname": "Jim", "lastname": "Doe", "login": "goper", "password":"douit", "changing_user_login": "opal"}');

SELECT * FROM system_user_schema.action_add_new_user ('{"firstname": "Milly", "lastname": "Kicks", "login": "mKicks", "password":"watch", "changing_user_login": "supero"}');
SELECT * FROM system_user_schema.action_add_new_user ('{"firstname": "Milly", "lastname": "Kicks", "login": "mKicks", "password":"watch", "changing_user_login": "opal"}');

*/
