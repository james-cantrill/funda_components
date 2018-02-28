--	test_action_load_report_list_jstree

SELECT * FROM system_user_schema.action_add_new_user ('{"firstname": "John", "lastname": "Appleton", "login": "jappl", "password":"river", "changing_user_login": "muser"}');
SELECT * FROM system_user_schema.action_user_login ('{"login": "jappl", "password":"river"}');
SELECT * FROM system_user_schema.action_change_user_allowed_actions ('{"login": "jappl", "service":"report_manager", "action":"load_report_list", "task":"allow", "changing_user_login": "muser"}');

SELECT * FROM system_user_schema.action_add_new_user ('{"firstname": "Roger", "lastname": "Fitzroger", "login": "opal", "password":"spade", "changing_user_login": "muser"}');
SELECT * FROM system_user_schema.action_change_user_allowed_actions ('{"login": "opal", "service":"report_manager", "action":"load_report_list", "task":"allow", "changing_user_login": "muser"}');

SELECT * FROM report_manager_schema.action_load_report_list_jstree ('{"login": "jappl"}');

SELECT * FROM report_manager_schema.action_load_report_list_jstree ('{"login": "opal"}');


