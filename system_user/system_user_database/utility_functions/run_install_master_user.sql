-- The function system_user_schema.install_master_user adds a master user to
-- the application during database installation

SELECT * FROM system_user_schema.install_master_user ('master');


-- SELECT * FROM system_user_schema.util_is_user_authorized ('{"login": "muser", "service":"system_user", "action": "add_new_user"}');

-- SELECT * FROM system_user_schema.action_add_new_user ('{"firstname": "Roger", "lastname": "Fitzroger", "login": "opal", "password":"spade", "changing_user_login": "muser"}');
