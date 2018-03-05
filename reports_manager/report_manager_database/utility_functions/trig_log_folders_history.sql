/* The function system_user_schema.trig_log_folders_history stores the audit records for the
* system_user_schema.system_user table
*/

CREATE OR REPLACE FUNCTION report_manager_schema.trig_log_folders_history()
  RETURNS trigger
AS $$

DECLARE
		
	_integer_var integer;
	
	_change_type	text;
	
BEGIN

	IF (TG_OP = 'UPDATE' AND TG_LEVEL = 'ROW') THEN
		_change_type := 'Update';
	ELSIF (TG_OP = 'DELETE' AND TG_LEVEL = 'ROW') THEN
		_change_type := 'Delete';
	END IF;
	
	INSERT INTO report_manager_schema.report_folders_history (
		folder_id,
		folder_name,
		folder_display_name,
		folder_description, 
		parent_folder_name,
		datetime_folder_change_started,
		datetime_folder_change_ended,
		changing_user_login,
		change_type
		)
	SELECT
		OLD.folder_id,
		OLD.folder_name,
		OLD.folder_display_name,
		OLD.folder_description, 
		OLD.parent_folder_name,
		OLD.datetime_folder_changed,
		LOCALTIMESTAMP (0),
		OLD.changing_user_login,
		_change_type
	;
	
	RETURN null;
	
	
END;
$$ LANGUAGE plpgsql;		

	DROP TRIGGER IF EXISTS trig_log_folders_history_up_or_del ON report_manager_schema.report_folders;
	
    CREATE TRIGGER trig_log_folders_history_up_or_del 
      AFTER UPDATE OR DELETE 
      ON report_manager_schema.report_folders  
      FOR EACH ROW  
      EXECUTE PROCEDURE report_manager_schema.trig_log_folders_history();  
	  
	

	  