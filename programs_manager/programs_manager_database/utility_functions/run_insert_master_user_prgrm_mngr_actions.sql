-- The function programs_manager_schema.insert_master_user_prgrm_mngr_actions
-- allows the master user to run all programs_manager actions. It is run as
-- the last step in the programs_manager installation

-- remove all existing actions
DELETE FROM system_user_schema.system_user_allowed_actions WHERE	service = 'programs_manager';

SELECT * FROM programs_manager_schema.insert_master_user_prgrm_mngr_actions ();
