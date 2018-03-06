/* The function action_enter_edit_allowed_reports


	_in_data:	{
					target_login:      -- can not be NULL
					report_id:       -- can not be NULL
                    report_name:
                    viewable: BOOLEAN   -- can not be NULL
					changing_user_login:     -- can not be NULL
				}
			
* The json object returned by the function, _out_json, is defined  below.

	_out_json:	{
					result_indicator:
					message:
					target_login:
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
	
	_report_name_from_id	text;
	_target_sysuser_id	uuid;
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

    IF (SELECT _in_data ->> 'target_login')::text IS NULL THEN 
        _message := (SELECT 'The target_login is missing so the visibility of the report CAN NOT be changed, please resubmit with complete data.');
        _out_json :=  (SELECT json_build_object(
                'result_indicator', 'Failure',
                'message', _message,
                'target_login', (SELECT _in_data ->> 'target_login')::text,
                'report_id', (SELECT _in_data ->> 'report_id')::text,
                'report_name', (SELECT _in_data ->> 'report_name')::text,
                'viewable', (SELECT _in_data ->> 'viewable')::text,
                'changing_user_login', (SELECT _in_data ->> 'changing_user_login')::text
                ));		
       
    ELSIF (SELECT _in_data ->> 'task')::text IS NULL THEN  
        _message := (SELECT 'The viewable parameter is missing so the visibility of the report CAN NOT be changed, please resubmit with complete data.');
        _out_json :=  (SELECT json_build_object(
                'result_indicator', 'Failure',
                'message', _message,
                'target_login', (SELECT _in_data ->> 'target_login')::text,
                'report_id', (SELECT _in_data ->> 'report_id')::text,
                'report_name', (SELECT _in_data ->> 'report_name')::text,
                'viewable', (SELECT _in_data ->> 'viewable')::text,
                'changing_user_login', (SELECT _in_data ->> 'changing_user_login')::text
                ));		
                
    ELSIF (SELECT _in_data ->> 'changing_user_login')::text IS NULL THEN  
        _message := (SELECT 'The changing_user_login is missing so the visibility of the report CAN NOT be changed, please resubmit with complete data.');
        _out_json :=  (SELECT json_build_object(
                'result_indicator', 'Failure',
                'message', _message,
                'target_login', (SELECT _in_data ->> 'target_login')::text,
                'report_id', (SELECT _in_data ->> 'report_id')::text,
                'report_name', (SELECT _in_data ->> 'report_name')::text,
                'viewable', (SELECT _in_data ->> 'viewable')::text,
                'changing_user_login', (SELECT _in_data ->> 'changing_user_login')::text
                ));		
                
    ELSIF (SELECT _in_data ->> 'report_id')::text IS NULL) THEN  
        _message := (SELECT 'The the report_id is missing so the visibility of the report CAN NOT be changed, please resubmit with complete data.');
        _out_json :=  (SELECT json_build_object(
                'result_indicator', 'Failure',
                'message', _message,
                'target_login', (SELECT _in_data ->> 'target_login')::text,
                'report_id', (SELECT _in_data ->> 'report_id')::text,
                'report_name', (SELECT _in_data ->> 'report_name')::text,
                'viewable', (SELECT _in_data ->> 'viewable')::text,
                'changing_user_login', (SELECT _in_data ->> 'changing_user_login')::text
                ));		
    
    ELSIF  NOT _authorized_result  THEN
        _message := 'The user ' || _calling_login || ' IS NOT Authorized to change the viewability of reports. Nothng was changed.';
		_out_json :=  (SELECT json_build_object(
                'result_indicator', 'Failure',
                'message', _message,
                'target_login', (SELECT _in_data ->> 'target_login')::text,
                'report_id', (SELECT _in_data ->> 'report_id')::text,
                'report_name', (SELECT _in_data ->> 'report_name')::text,
                'viewable', (SELECT _in_data ->> 'task')::text,
                'changing_user_login', (SELECT _in_data ->> 'changing_user_login')::text
                ));	
    
    ELSE    -- nothing is missing and the user is authorized so process the change
    
        -- does the report exist
        _report_name_from_id := (SELECT report_name
                    FROM    report_manager_schema.reports
                    WHERE   report_id = (SELECT _in_data ->> 'report_id')::uuid
                    );
       
        -- does the user exist
        _target_sysuser_id :=	(SELECT sysuser_id
                    FROM system_user_schema.system_users
                    WHERE login = (SELECT _in_data ->> 'target_login')::text
                );
    
        IF _report_name_from_id IS NULL THEN   -- report does not exist
            _message := 'The report specified by the report_id, ' || (SELECT _in_data ->> 'report_id')::text || ' DOES NOT EXIST. Nothng was changed.';
            _out_json :=  (SELECT json_build_object(
                'result_indicator', 'Failure',
                'message', _message,
                'target_login', (SELECT _in_data ->> 'target_login')::text,
                'report_id', (SELECT _in_data ->> 'report_id')::text,
                'report_name', (SELECT _in_data ->> 'report_name')::text,
                'viewable', (SELECT _in_data ->> 'task')::text,
                'changing_user_login', (SELECT _in_data ->> 'changing_user_login')::text
                ));	
        ELSIF _target_sysuser_id IS NULL THEN   -- target user does not exist
           _message := 'The target user specified by the target_login, ' || (SELECT _in_data ->> 'target_login')::text || ' DOES NOT EXIST. Nothng was changed.';
            _out_json :=  (SELECT json_build_object(
                'result_indicator', 'Failure',
                'message', _message,
                'target_login', (SELECT _in_data ->> 'target_login')::text,
                'report_id', (SELECT _in_data ->> 'report_id')::text,
                'report_name', (SELECT _in_data ->> 'report_name')::text,
                'viewable', (SELECT _in_data ->> 'task')::text,
                'changing_user_login', (SELECT _in_data ->> 'changing_user_login')::text
                ));	
        
        ELSE
            -- does the target user already have an entry for this report
            _report_viewable :=	(SELECT report_viewable
                    FROM report_manager_schema.system_user_allowed_reports
                    WHERE sysuser_id = _target_sysuser_id
                      AND report_id = (SELECT _in_data ->> 'report_id')::uuid
                );
            
            IF _report_viewable IS NULL THEN  -- an entry does not exist so insert
            
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
					_target_sysuser_id,
					(SELECT _in_data ->> 'login')::text,
					(SELECT _in_data ->> 'report_id')::uuid,
					_report_name_from_id,
					(SELECT _in_data ->> 'task')::BOOLEAN,
					LOCALTIMESTAMP (0),
					(SELECT _in_data ->> 'changing_user_login')::text
				;
				
				_message := 'The report ' || _report_name || ' is now VISIBLE to ' ||  _firstname || ' ' || _lastname ;		
                _out_json :=  (SELECT json_build_object(
                    'result_indicator', 'Failure',
                    'message', _message,
                    'target_login', (SELECT _in_data ->> 'target_login')::text,
                    'report_id', (SELECT _in_data ->> 'report_id')::text,
                    'report_name', (SELECT _in_data ->> 'report_name')::text,
                    'viewable', (SELECT _in_data ->> 'viewable')::text,
                    'changing_user_login', (SELECT _in_data ->> 'changing_user_login')::text
                    ));		
                    
            ELSE   -- update the existing entry
            
            UPDATE	report_manager_schema.system_user_allowed_reports
					   SET	report_viewable = TRUE,
							datetime_report_viewable_changed = LOCALTIMESTAMP (0)
					WHERE	login = (SELECT _in_data ->> 'login')::text
					  AND	report_id = _report_id
					;
				
					_message := (SELECT 'The report ' || _report_name_from_id  || ' has been updated to visible for ' ||  (SELECT _in_data ->> 'target_login')::text);
                    _out_json :=  (SELECT json_build_object(
                    'result_indicator', 'Failure',
                    'message', _message,
                    'target_login', (SELECT _in_data ->> 'target_login')::text,
                    'report_id', (SELECT _in_data ->> 'report_id')::text,
                    'report_name', (SELECT _in_data ->> 'report_name')::text,
                    'viewable', (SELECT _in_data ->> 'viewable')::text,
                    'changing_user_login', (SELECT _in_data ->> 'changing_user_login')::text
                    ));	
                    
            END IF;
            
        END IF; 
        
        
    END IF;
    
    

	
	RETURN _out_json;
	
	
END;
$$ LANGUAGE plpgsql;		