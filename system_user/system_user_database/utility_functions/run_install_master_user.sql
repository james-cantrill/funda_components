-- The function system_user_schema.install_master_user adds a master user to
-- the application during database installation

SELECT * FROM system_user_schema.install_master_user ('master');

