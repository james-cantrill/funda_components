/* The function action_enter_edit_allowed_reports


	_in_data:	{
					login:
					report_id:
					report_name:
					task:	// viewable (set system_user_allowed_reports.report_viewable to TRUE) or not_viewable (set system_user_allowed_reports.report_viewable to FALSE)
					changing_user_login:
				}
			
* The json object returned by the function, _out_json, is defined  below.

	_out_json:	{
					result_indicator:
					message:
					login:
					report_id:
					report_name:
					viewable:
					changing_user_login:
				}
				

*/

CREATE OR REPLACE FUNCTION report_manager_schema.action_enter_edit_allowed_reports (_in_data json) RETURNS json
AS $$

DECLARE
		
	_out_json json;
	
	_firstname	text;
	_lastname	text;
	
	_sysuser_id	uuid;
	_report_id	uuid;
	_test_report_id	uuid;
	_report_name	text;
	_test_report_name	text;
	_report_viewable	boolean;
	
	_message	text;
	
--	for calling the system_user_schema.util_is_user_authorized function to determine if the calling user is authorized to add new users
	_calling_login	text;
	_input_authorized_json	json;	-- input json
	_output_authorized_json	json;	-- output json  
	_authorized_result	boolean;
	
BEGIN

	-- Determine if the calling user is authorized
	_calling_login := (SELECT _in_data ->> 'changing_user_login')::text;
	
	_input_authorized_json :=	(SELECT json_build_object(
							'login', _calling_login,
							'service', 'report_manager',
							'action', 'enter_edit_allowed_reports'
							));
	
	_output_authorized_json := (SELECT * FROM system_user_schema.util_is_user_authorized (_input_authorized_json));
	
	_authorized_result := (SELECT _output_authorized_json ->> 'authorized')::boolean;

	IF _authorized_result  THEN
	

		-- check if the submitted data is complete
		IF (SELECT _in_data ->> 'login')::text IS NULL OR (SELECT _in_data ->> 'task')::text IS NULL OR (SELECT _in_data ->> 'changing_user_login')::text IS NULL OR ((SELECT _in_data ->> 'report_name')::text IS NULL AND (SELECT _in_data ->> 'report_id')::text IS NULL) THEN -- data is incomplete
		
			_message := (SELECT 'The data is incomplete as submitted so the report CAN NOT be entered or edited, please resubmit with complete data.') ;
			_out_json :=  (SELECT json_build_object(
								'result_indicator', 'Failure',
								'message', _message,
								'report_name', (SELECT _in_data ->> 'report_name')::text,
								'description', (SELECT _in_data ->> 'description')::text,
								'url', (SELECT _in_data ->> 'url')::text,
								'containing_folder_name', (SELECT _in_data ->> 'containing_folder_name')::text,
								'insert_or_update', (SELECT _in_data ->> 'insert_or_update')::text, 
								'changing_user_login', (SELECT _in_data ->> 'changing_user_login')::text
								));		
								
		ELSE	--data is complete so we proceed
							
			_firstname := (	SELECT
								firstname
							FROM	system_user_schema.system_users
							WHERE	login = (SELECT _in_data ->> 'login')::text
							);
			
			_lastname := (	SELECT
								lastname
							FROM	system_user_schema.system_users
							WHERE	login = (SELECT _in_data ->> 'login')::text
							);
			
			-- make sure that both the report_id and report_name aren't null
			IF (SELECT _in_data ->> 'report_id')::uuid IS NULL THEN 			
				_report_id := (	SELECT
										report_id
									FROM	report_manager_schema.reports
									WHERE	report_name = (SELECT _in_data ->> 'report_name')::text
								);		
				_report_name := (SELECT _in_data ->> 'report_name')::text;
				
			ELSE
				_report_id := (SELECT _in_data ->> 'report_id')::uuid;
				
				_report_name := (	SELECT
										report_name
									FROM	report_manager_schema.reports
									WHERE	report_id = (SELECT _in_data ->> 'report_id')::uuid
								);				
			END IF;			

			-- is there already an entry for this login and report identified by either the report_id or the report_name
			 _test_report_id  := (	SELECT 
									report_id 
								FROM report_manager_schema.system_user_allowed_reports
								WHERE login = (SELECT _in_data ->> 'login')::text
								  AND  (report_name = _report_name OR report_id = _report_id)
								);
								
			IF  _test_report_id  IS NOT NULL THEN	-- the user already has an entry for this report and we can change it
			
				_report_viewable := (SELECT
											report_viewable
										FROM	report_manager_schema.system_user_allowed_reports
										WHERE	 login = (SELECT _in_data ->> 'login')::text
										  AND	report_id = _report_id
									);	
				IF (SELECT _in_data ->> 'task')::text = 'viewable' AND NOT _report_viewable THEN
				
					_report_viewable := TRUE;
					
					UPDATE	report_manager_schema.system_user_allowed_reports
					   SET	report_viewable = TRUE,
							datetime_report_viewable_changed = LOCALTIMESTAMP (0)
					WHERE	login = (SELECT _in_data ->> 'login')::text
					  AND	report_id = _report_id
					;
				
					_message := (SELECT 'The report ' || _report_name  || ' has been updated to visible for ' ||  _firstname || ' ' || _lastname );
					
					_out_json :=  (SELECT json_build_object(
								'result_indicator', 'Success',
								'message', _message,
								'login', (SELECT _in_data ->> 'login')::text,
								'report_id', (SELECT _in_data ->> 'report_id')::text,
								'report_name', (SELECT _in_data ->> 'report_name')::text,
								'viewable', _report_viewable,
								'changing_user_login', (SELECT _in_data ->> 'changing_user_login')::text
								));				
					
				ELSIF (SELECT _in_data ->> 'task')::text = 'not_viewable'  AND NOT _report_viewable THEN
							
					_message := 'The report ' || _report_name || ' is already not visible to ' ||  _firstname || ' ' || _lastname || '. Nothing will be done.' ;
					
					_out_json :=  (SELECT json_build_object(
								'result_indicator', 'Fail;ure',
								'message', _message,
								'login', (SELECT _in_data ->> 'login')::text,
								'report_id', (SELECT _in_data ->> 'report_id')::text,
								'report_name', (SELECT _in_data ->> 'report_name')::text,
								'viewable', _report_viewable,
								'changing_user_login', (SELECT _in_data ->> 'changing_user_login')::text
								));		
								
				ELSIF (SELECT _in_data ->> 'task')::text = 'viewable'  AND  _report_viewable THEN
				
					_message := 'The report ' || _report_name || ' is already visible to ' ||  _firstname || ' ' || _lastname || '. Nothing will be done.' ;
					
					_out_json :=  (SELECT json_build_object(
								'result_indicator', 'Failure',
								'message', _message,
								'login', (SELECT _in_data ->> 'login')::text,
								'report_id', (SELECT _in_data ->> 'report_id')::text,
								'report_name', (SELECT _in_data ->> 'report_name')::text,
								'viewable', _report_viewable,
								'changing_user_login', (SELECT _in_data ->> 'changing_user_login')::text
								));		
								
							
				ELSIF (SELECT _in_data ->> 'task')::text = 'not_viewable'  AND  _report_viewable THEN
					_report_viewable := FALSE;
					
					UPDATE	report_manager_schema.system_user_allowed_reports
					   SET	report_viewable = FALSE,
							datetime_report_viewable_changed = LOCALTIMESTAMP (0)
					WHERE	login = (SELECT _in_data ->> 'login')::text
					  AND	report_id = _report_id
					;
				
					_message := (SELECT 'The report ' || _report_name  || ' has been updated to not visible for ' ||  _firstname || ' ' || _lastname );
					
					_out_json :=  (SELECT json_build_object(
								'result_indicator', 'Success',
								'message', _message,
								'login', (SELECT _in_data ->> 'login')::text,
								'report_id', (SELECT _in_data ->> 'report_id')::text,
								'report_name', (SELECT _in_data ->> 'report_name')::text,
								'viewable', _report_viewable,
								'changing_user_login', (SELECT _in_data ->> 'changing_user_login')::text
								));				
											
				END IF;
				
				
				
			ELSE	-- IF _report_id IS NOT NULL THEN	-- the user does not have an entry for this program so we add it
		
				_sysuser_id := (	SELECT 
										sysuser_id 
									FROM system_user_schema.system_users 
									WHERE login = lower ((SELECT _in_data ->> 'login'))
									);
									
				IF (SELECT _in_data ->> 'task')::text = 'viewable' THEN
					_report_viewable := TRUE;
				ELSIF (SELECT _in_data ->> 'task')::text = 'not_viewable' THEN
					_report_viewable := FALSE;			
				END IF;
				
				INSERT INTO report_manager_schema.system_user_allowed_reports (
					sysuser_id,
					login,
					report_id,
					report_name,
					report_viewable,
					datetime_report_viewable_changed,
					changing_user_login					
					)
				SELECT
					_sysuser_id,
					(SELECT _in_data ->> 'login')::text,
					_report_id,
					_report_name,	-- (SELECT _in_data ->> 'report_name')::text,
					_report_viewable,
					LOCALTIMESTAMP (0),
					(SELECT _in_data ->> 'changing_user_login')::text
				;
					
					
				_message := 'The report ' || _report_name || ' is now VISIBLE to ' ||  _firstname || ' ' || _lastname ;		
				_out_json :=  (SELECT json_build_object(
								'result_indicator', 'Success',
								'message', _message,
								'login', (SELECT _in_data ->> 'login')::text,
								'report_id', (SELECT _in_data ->> 'report_id')::text,
								'report_name', (SELECT _in_data ->> 'report_name')::text,
								'viewable', _report_viewable,
								'changing_user_login', (SELECT _in_data ->> 'changing_user_login')::text
								));	
								
			END IF;
			
		END IF;
		
	ELSE-- user isn't authorized to enter or edit reports
	
		_message := 'The user ' || _calling_login || ' IS NOT Authorized to change the viewability of reports. Nothng was changed.';
		
		_out_json :=  (SELECT json_build_object(
							'result_indicator', 'Failure',
							'message', _message,
							'login', (SELECT _in_data ->> 'login')::text,
							'report_id', (SELECT _in_data ->> 'login')::text,
							'report_name', (SELECT _in_data ->> 'report_name')::text,
							'viewable', (SELECT _in_data ->> 'task')::text,
							'changing_user_login', (SELECT _in_data ->> 'changing_user_login')::text
							));	

	END IF;
	
	
	RETURN _out_json;
	
	
END;
$$ LANGUAGE plpgsql;		