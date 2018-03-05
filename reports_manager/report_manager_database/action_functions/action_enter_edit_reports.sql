-- The function report_manager_schema.action_enter_edit_reports adds a report
-- to the system or updates an existing report ujsing the _in_data json object.

--	_in_data:	
--	{
--		report_id:	required for update NULL for insert
--		report_name:	-- NOT NULL
--		description:	-- NOT NULL
--		url:	-- NOT NULL
--		containing_folder_name:	-- NOT NULL
--		changing_user_login:	-- NOT NULL
--		parameters:	[	]	
--		insert_or_update:	// text allowed values, insert, update
--	}
			
-- The json object returned by the function, _out_json, is defined  below.

--	_in_data:	
--	{
--		result_indicator:
--		message:
--		report_id:
--		report_name:
--		description:
--		url:
--		containing_folder_name:
--		changing_user_login:
--		parameters:	[	]
--		insert_or_update:	// text allowed values, insert, update
--	}

CREATE OR REPLACE FUNCTION report_manager_schema.action_enter_edit_reports (_in_data json) RETURNS json
AS $$

DECLARE
	_integer_var	integer;
	_out_json json;
	_message	text;
	_result_indicator	text;
	
	_report_id_from_name	uuid;
	_report_id_from_url	uuid;
	_report_id	uuid;
	
	_report_name_from_id	text;
	_url_from_id	text;
	
	_input_report_param_json	json;	
	_output_report_param_json	json;

	_containing_folder_id	uuid;
	_old_containing_folder_name	text;
	_containing_folder_exists	boolean;
	_containing_folder_name_updateable	boolean;
	
	_old_report_name	text;
	_report_name_updateable	boolean;
	_report_name_exists	boolean;
	
	_old_url	text;
	_url_updateable	boolean;
	_url_exists	boolean;
	
--	for calling the system_user_schema.util_is_user_authorized function to determine if the calling user is authorized to add new users
	_calling_login	text;
	_input_authorized_json	json;	-- input json
	_output_authorized_json	json;	-- output json  
	_authorized_result	boolean;	

BEGIN
	
	_calling_login := (SELECT _in_data ->> 'changing_user_login')::text;	
	_input_authorized_json :=	(SELECT json_build_object(
							'login', _calling_login,
							'service', 'report_manager',
							'action', 'enter_edit_folders'
							));	
	_output_authorized_json := (SELECT * FROM system_user_schema.util_is_user_authorized (_input_authorized_json));	
	_authorized_result := (SELECT _output_authorized_json ->> 'authorized')::boolean;
	
	-- test for incomplete data 
	IF (SELECT _in_data ->> 'report_name')::text IS NULL THEN 
	
		_message := (SELECT 'The report_name is missing so the report CAN NOT be entered or edited, please resubmit with complete data.') ;
		
		_out_json :=  (SELECT json_build_object(
							'result_indicator', 'Failure',
							'message', _message,
							'report_id', (SELECT _in_data ->> 'report_id')::text,
							'report_name', (SELECT _in_data ->> 'report_name')::text,
							'description', (SELECT _in_data ->> 'description')::text,
							'url', (SELECT _in_data ->> 'url')::text,
							'containing_folder_name', (SELECT _in_data ->> 'containing_folder_name')::text,
							'changing_user_login', (SELECT _in_data ->> 'changing_user_login')::text,
							'parameters', (SELECT _in_data -> 'parameters'),
							'insert_or_update', (SELECT _in_data ->> 'insert_or_update')::text
							));		
							
	ELSIF (SELECT _in_data ->> 'description')::text IS NULL THEN 
	
		_message := (SELECT 'The description is missing so the report CAN NOT be entered or edited, please resubmit with complete data.') ;
		
		_out_json :=  (SELECT json_build_object(
							'result_indicator', 'Failure',
							'message', _message,
							'report_id', (SELECT _in_data ->> 'report_id')::text,
							'report_name', (SELECT _in_data ->> 'report_name')::text,
							'description', (SELECT _in_data ->> 'description')::text,
							'url', (SELECT _in_data ->> 'url')::text,
							'containing_folder_name', (SELECT _in_data ->> 'containing_folder_name')::text,
							'changing_user_login', (SELECT _in_data ->> 'changing_user_login')::text,
							'parameters', (SELECT _in_data -> 'parameters'),
							'insert_or_update', (SELECT _in_data ->> 'insert_or_update')::text
							));		
								
	ELSIF (SELECT _in_data ->> 'url')::text IS NULL THEN 
		_message := (SELECT 'The url is missing so the report CAN NOT be entered or edited, please resubmit with complete data.') ;
		
		_out_json :=  (SELECT json_build_object(
							'result_indicator', 'Failure',
							'message', _message,
							'report_id', (SELECT _in_data ->> 'report_id')::text,
							'report_name', (SELECT _in_data ->> 'report_name')::text,
							'description', (SELECT _in_data ->> 'description')::text,
							'url', (SELECT _in_data ->> 'url')::text,
							'containing_folder_name', (SELECT _in_data ->> 'containing_folder_name')::text,
							'changing_user_login', (SELECT _in_data ->> 'changing_user_login')::text,
							'parameters', (SELECT _in_data -> 'parameters'),
							'insert_or_update', (SELECT _in_data ->> 'insert_or_update')::text
							));		
									
	ELSIF (SELECT _in_data ->> 'containing_folder_name')::text IS NULL THEN 
		_message := (SELECT 'The containing_folder_name is missing so the report CAN NOT be entered or edited, please resubmit with complete data.') ;
		
		_out_json :=  (SELECT json_build_object(
							'result_indicator', 'Failure',
							'message', _message,
							'report_id', (SELECT _in_data ->> 'report_id')::text,
							'report_name', (SELECT _in_data ->> 'report_name')::text,
							'description', (SELECT _in_data ->> 'description')::text,
							'url', (SELECT _in_data ->> 'url')::text,
							'containing_folder_name', (SELECT _in_data ->> 'containing_folder_name')::text,
							'changing_user_login', (SELECT _in_data ->> 'changing_user_login')::text,
							'parameters', (SELECT _in_data -> 'parameters'),
							'insert_or_update', (SELECT _in_data ->> 'insert_or_update')::text
							));		
									
	ELSIF (SELECT _in_data ->> 'changing_user_login')::text IS NULL THEN 
		_message := (SELECT 'The changing_user_login is missing so the report CAN NOT be entered or edited, please resubmit with complete data.') ;
		
		_out_json :=  (SELECT json_build_object(
							'result_indicator', 'Failure',
							'message', _message,
							'report_id', (SELECT _in_data ->> 'report_id')::text,
							'report_name', (SELECT _in_data ->> 'report_name')::text,
							'description', (SELECT _in_data ->> 'description')::text,
							'url', (SELECT _in_data ->> 'url')::text,
							'containing_folder_name', (SELECT _in_data ->> 'containing_folder_name')::text,
							'changing_user_login', (SELECT _in_data ->> 'changing_user_login')::text,
							'parameters', (SELECT _in_data -> 'parameters'),
							'insert_or_update', (SELECT _in_data ->> 'insert_or_update')::text
							));		
									
	ELSIF (SELECT _in_data ->> 'insert_or_update')::text IS NULL THEN 
		_message := (SELECT 'The insert_or_update is missing so the report CAN NOT be entered or edited, please resubmit with complete data.') ;
		
		_out_json :=  (SELECT json_build_object(
							'result_indicator', 'Failure',
							'message', _message,
							'report_id', (SELECT _in_data ->> 'report_id')::text,
							'report_name', (SELECT _in_data ->> 'report_name')::text,
							'description', (SELECT _in_data ->> 'description')::text,
							'url', (SELECT _in_data ->> 'url')::text,
							'containing_folder_name', (SELECT _in_data ->> 'containing_folder_name')::text,
							'changing_user_login', (SELECT _in_data ->> 'changing_user_login')::text,
							'parameters', (SELECT _in_data -> 'parameters'),
							'insert_or_update', (SELECT _in_data ->> 'insert_or_update')::text
							));		
									
	ELSIF  (lower((SELECT _in_data ->> 'insert_or_update')::text) = 'update'
					AND (SELECT _in_data ->> 'report_id')::text IS NULL 
				) THEN 
		
		_message := (SELECT 'The report_id is missing  so the report CAN NOT be UPDATED, please resubmit with complete data.');
		
		_out_json :=  (SELECT json_build_object(
							'result_indicator', 'Failure',
							'message', _message,
							'report_id', (SELECT _in_data ->> 'report_id')::text,
							'report_name', (SELECT _in_data ->> 'report_name')::text,
							'description', (SELECT _in_data ->> 'description')::text,
							'url', (SELECT _in_data ->> 'url')::text,
							'containing_folder_name', (SELECT _in_data ->> 'containing_folder_name')::text,
							'changing_user_login', (SELECT _in_data ->> 'changing_user_login')::text,
							'parameters', (SELECT _in_data -> 'parameters'),
							'insert_or_update', (SELECT _in_data ->> 'insert_or_update')::text
							));		
									

	ELSIF NOT _authorized_result  THEN
	-- user isn't authorized to enter or edit reports
		_message := 'The user ' || _calling_login || ' IS NOT Authorized to enter or edit reports. Nothng was changed.';

		_out_json :=  (SELECT json_build_object(
							'result_indicator', 'Failure',
							'message', _message,
							'report_id', (SELECT _in_data ->> 'report_id')::text,
							'report_name', (SELECT _in_data ->> 'report_name')::text,
							'description', (SELECT _in_data ->> 'description')::text,
							'url', (SELECT _in_data ->> 'url')::text,
							'containing_folder_name', (SELECT _in_data ->> 'containing_folder_name')::text,
							'changing_user_login', (SELECT _in_data ->> 'changing_user_login')::text,
							'parameters', (SELECT _in_data -> 'parameters'),
							'insert_or_update', (SELECT _in_data ->> 'insert_or_update')::text
							));		
							
	ELSE	-- process the insert or update
	
		-- does the containing folder exist
		_containing_folder_id :=	(SELECT
					folder_id
				FROM	report_manager_schema.report_folders
				WHERE	folder_name = (SELECT _in_data ->> 'containing_folder_name')::text 
				);	

		IF _containing_folder_id IS NULL THEN
		
			_message := (SELECT 'The folder with the submitted containing folder name, ' || (SELECT _in_data ->> 'containing_folder_name')::text || ', DOES NOT EXIST so the report CAN NOT be entered or edited, please resubmit with correct data.') ;
			_out_json :=  (SELECT json_build_object(
							'result_indicator', 'Failure',
							'message', _message,
							'report_id', (SELECT _in_data ->> 'report_id')::text,
							'report_name', (SELECT _in_data ->> 'report_name')::text,
							'description', (SELECT _in_data ->> 'description')::text,
							'url', (SELECT _in_data ->> 'url')::text,
							'containing_folder_name', (SELECT _in_data ->> 'containing_folder_name')::text,
							'changing_user_login', (SELECT _in_data ->> 'changing_user_login')::text,
							'parameters', (SELECT _in_data -> 'parameters'),
							'insert_or_update', (SELECT _in_data ->> 'insert_or_update')::text
							));		
			
		ELSIF lower ((SELECT _in_data ->> 'insert_or_update')::text) = 'insert' THEN				
			-- is the report name unique
			_report_id_from_name := (	SELECT 
									report_id 
								FROM report_manager_schema.reports 
								WHERE report_name = (SELECT _in_data ->> 'report_name')::text
								);
		
			-- is the url unique
			_report_id_from_url	:= (	SELECT 
									report_id 
								FROM report_manager_schema.reports 
								WHERE url = (SELECT _in_data ->> 'url')::text
								);
		
			IF _report_id_from_name IS NOT NULL THEN
				_message := (SELECT 'The submitted report name, ' || (SELECT _in_data ->> 'report_name')::text || ', already exists, please choose another.') ;
				_out_json :=  (SELECT json_build_object(
							'result_indicator', 'Failure',
							'message', _message,
							'report_id', (SELECT _in_data ->> 'report_id')::text,
							'report_name', (SELECT _in_data ->> 'report_name')::text,
							'description', (SELECT _in_data ->> 'description')::text,
							'url', (SELECT _in_data ->> 'url')::text,
							'containing_folder_name', (SELECT _in_data ->> 'containing_folder_name')::text,
							'changing_user_login', (SELECT _in_data ->> 'changing_user_login')::text,
							'parameters', (SELECT _in_data -> 'parameters'),
							'insert_or_update', (SELECT _in_data ->> 'insert_or_update')::text
							));
				
			ELSIF _report_id_from_url IS NOT NULL THEN
				_message := (SELECT 'The submitted URL, ' || (SELECT _in_data ->> 'url')::text || ', already exists, please choose another.');
				_out_json :=  (SELECT json_build_object(
							'result_indicator', 'Failure',
							'message', _message,
							'report_id', (SELECT _in_data ->> 'report_id')::text,
							'report_name', (SELECT _in_data ->> 'report_name')::text,
							'description', (SELECT _in_data ->> 'description')::text,
							'url', (SELECT _in_data ->> 'url')::text,
							'containing_folder_name', (SELECT _in_data ->> 'containing_folder_name')::text,
							'changing_user_login', (SELECT _in_data ->> 'changing_user_login')::text,
							'parameters', (SELECT _in_data -> 'parameters'),
							'insert_or_update', (SELECT _in_data ->> 'insert_or_update')::text
							));
			ELSE
				INSERT INTO report_manager_schema.reports (
					report_name,
					description,
					url,
					containing_folder_name,
					datetime_report_added,
					changing_user_login
					)
				VALUES	(
					(SELECT _in_data ->> 'report_name')::text, 
					(SELECT _in_data ->> 'description')::text,
					(SELECT _in_data ->> 'url')::text, 
					(SELECT _in_data ->> 'containing_folder_name')::text,
					LOCALTIMESTAMP (0),
					(SELECT _in_data ->> 'changing_user_login')::text
					)
				;
				_report_id	:= (SELECT 
								report_id 
							FROM report_manager_schema.reports 
							WHERE report_name = (SELECT _in_data ->> 'report_name')::text
							);
							
				_input_report_param_json :=  (SELECT json_build_object(
									'report_id', _report_id,
									'insert_or_update', (SELECT _in_data ->> 'insert_or_update')::text, 
									'changing_user_login', (SELECT _in_data ->> 'changing_user_login')::text,
									'parameters', (SELECT _in_data -> 'parameters')
									));
									
				_output_report_param_json := (SELECT * FROM report_manager_schema.action_enter_edit_report_parameters (_input_report_param_json));
					
				IF (SELECT _output_report_param_json ->> 'result_indicator')::text = 'Success' THEN					
					_message := (SELECT 'The report ' || (SELECT _in_data ->> 'report_name')::text || ' has been added to the system.');
					_out_json :=  (SELECT json_build_object(
							'result_indicator', 'Success',
							'message', _message,
							'report_id', (SELECT _in_data ->> 'report_id')::text,
							'report_name', (SELECT _in_data ->> 'report_name')::text,
							'description', (SELECT _in_data ->> 'description')::text,
							'url', (SELECT _in_data ->> 'url')::text,
							'containing_folder_name', (SELECT _in_data ->> 'containing_folder_name')::text,
							'changing_user_login', (SELECT _in_data ->> 'changing_user_login')::text,
							'parameters', (SELECT _in_data -> 'parameters'),
							'insert_or_update', (SELECT _in_data ->> 'insert_or_update')::text
							));
				ELSE
					DELETE FROM report_manager_schema.report_parameters WHERE report_id = _report_id;
					DELETE FROM report_manager_schema.reports WHERE report_id = _report_id;
					
					_message := (SELECT 'There is an error in the parameters ERROR: ' || (SELECT _output_report_param_json ->> 'message')::text || ' Nothing was inserted.');
					_out_json :=  (SELECT json_build_object(
							'result_indicator', 'Failure',
							'message', _message,
							'report_id', (SELECT _in_data ->> 'report_id')::text,
							'report_name', (SELECT _in_data ->> 'report_name')::text,
							'description', (SELECT _in_data ->> 'description')::text,
							'url', (SELECT _in_data ->> 'url')::text,
							'containing_folder_name', (SELECT _in_data ->> 'containing_folder_name')::text,
							'changing_user_login', (SELECT _in_data ->> 'changing_user_login')::text,
							'parameters', (SELECT _in_data -> 'parameters'),
							'insert_or_update', (SELECT _in_data ->> 'insert_or_update')::text
							));
				END IF;							
			END IF;

		ELSIF lower ((SELECT _in_data ->> 'insert_or_update')::text) = 'update' THEN	-- update the record
		
			_report_name_from_id	:= (SELECT 
								report_name 
							FROM report_manager_schema.reports 
							WHERE report_id = (SELECT _in_data ->> 'report_id')::uuid
							);
							
			_url_from_id	:= (SELECT 
								url 
							FROM report_manager_schema.reports 
							WHERE report_id = (SELECT _in_data ->> 'report_id')::uuid
							);
							
			IF _report_name_from_id != (SELECT _in_data ->> 'report_name')::text THEN  -- report name is being changed
				-- is the new report name unique
			_report_id_from_name := (	SELECT 
									report_id 
								FROM report_manager_schema.reports 
								WHERE report_name = (SELECT _in_data ->> 'report_name')::text
								);
			END IF;
			
			IF _url_from_id != (SELECT _in_data ->> 'url')::text THEN  -- url is being changed
			-- is the url unique
			_report_id_from_url	:= (	SELECT 
									report_id 
								FROM report_manager_schema.reports 
								WHERE url = (SELECT _in_data ->> 'url')::text
								);
		
			END IF;
			
			
			IF _report_name_from_id IS NULL THEN
			
				_message := (SELECT  'No report with the submitted report_id ' || (SELECT _in_data ->> 'report_id')::text || ' exists  so this update CAN NOT be completed, please resubmit with different data.') ;
				_out_json :=  (SELECT json_build_object(
					'result_indicator', 'Failure',
					'message', _message,
					'report_id', (SELECT _in_data ->> 'report_id')::text,
					'report_name', (SELECT _in_data ->> 'report_name')::text,
					'description', (SELECT _in_data ->> 'description')::text,
					'url', (SELECT _in_data ->> 'url')::text,
					'containing_folder_name', (SELECT _in_data ->> 'containing_folder_name')::text,
					'changing_user_login', (SELECT _in_data ->> 'changing_user_login')::text,
					'parameters', (SELECT _in_data -> 'parameters'),
					'insert_or_update', (SELECT _in_data ->> 'insert_or_update')::text
					));
			ELSIF _report_name_from_id != (SELECT _in_data ->> 'report_name')::text AND _report_id_from_name IS NOT NULL THEN
			
				_message := (SELECT 'The submitted report name, ' || (SELECT _in_data ->> 'report_name')::text || ', already exists, please choose another.') ;
				_out_json :=  (SELECT json_build_object(
					'result_indicator', 'Failure',
					'message', _message,
					'report_id', (SELECT _in_data ->> 'report_id')::text,
					'report_name', (SELECT _in_data ->> 'report_name')::text,
					'description', (SELECT _in_data ->> 'description')::text,
					'url', (SELECT _in_data ->> 'url')::text,
					'containing_folder_name', (SELECT _in_data ->> 'containing_folder_name')::text,
					'changing_user_login', (SELECT _in_data ->> 'changing_user_login')::text,
					'parameters', (SELECT _in_data -> 'parameters'),
					'insert_or_update', (SELECT _in_data ->> 'insert_or_update')::text
					));
					
			ELSIF _url_from_id != (SELECT _in_data ->> 'url')::text AND _report_id_from_url IS NOT NULL THEN
			
				_message := (SELECT 'The submitted URL, ' || (SELECT _in_data ->> 'url')::text || ', already exists, please choose another.');
				_out_json :=  (SELECT json_build_object(
					'result_indicator', 'Failure',
					'message', _message,
					'report_id', (SELECT _in_data ->> 'report_id')::text,
					'report_name', (SELECT _in_data ->> 'report_name')::text,
					'description', (SELECT _in_data ->> 'description')::text,
					'url', (SELECT _in_data ->> 'url')::text,
					'containing_folder_name', (SELECT _in_data ->> 'containing_folder_name')::text,
					'changing_user_login', (SELECT _in_data ->> 'changing_user_login')::text,
					'parameters', (SELECT _in_data -> 'parameters'),
					'insert_or_update', (SELECT _in_data ->> 'insert_or_update')::text
					));
					
			ELSE
			
				_input_report_param_json :=  (SELECT json_build_object(
										'report_id', (SELECT _in_data ->> 'report_id')::uuid,
										'insert_or_update', (SELECT _in_data ->> 'insert_or_update')::text, 
										'changing_user_login', (SELECT _in_data ->> 'changing_user_login')::text,
										'parameters', (SELECT _in_data -> 'parameters')
										));			
				
				_output_report_param_json := (SELECT * FROM report_manager_schema.action_enter_edit_report_parameters (_input_report_param_json));			
				
				IF (SELECT _output_report_param_json ->> 'result_indicator')::text = 'Success' THEN
					UPDATE report_manager_schema.reports 
					SET	report_name = (SELECT _in_data ->> 'report_name')::text, 
						description = (SELECT _in_data ->> 'description')::text,
						url = (SELECT _in_data ->> 'url')::text, 
						containing_folder_name = (SELECT _in_data ->> 'containing_folder_name')::text,
						datetime_report_added = LOCALTIMESTAMP (0),
						changing_user_login = (SELECT _in_data ->> 'changing_user_login')::text
					WHERE	report_id = (SELECT _in_data ->> 'report_id')::uuid	
					;								
					_message := (SELECT 'The report ' || (SELECT _in_data ->> 'report_name')::text || ' has been updated.');
					_out_json :=  (SELECT json_build_object(
					'result_indicator', 'Success',
					'message', _message,
					'report_id', (SELECT _in_data ->> 'report_id')::text,
					'report_name', (SELECT _in_data ->> 'report_name')::text,
					'description', (SELECT _in_data ->> 'description')::text,
					'url', (SELECT _in_data ->> 'url')::text,
					'containing_folder_name', (SELECT _in_data ->> 'containing_folder_name')::text,
					'changing_user_login', (SELECT _in_data ->> 'changing_user_login')::text,
					'parameters', (SELECT _in_data -> 'parameters'),
					'insert_or_update', (SELECT _in_data ->> 'insert_or_update')::text
					));
				ELSE
					_message := (SELECT 'There is an error in the parameters ERROR: ' || (SELECT _output_report_param_json ->> 'message')::text || ' Nothing was updated.');
					_out_json :=  (SELECT json_build_object(
					'result_indicator', 'Failure',
					'message', _message,
					'report_id', (SELECT _in_data ->> 'report_id')::text,
					'report_name', (SELECT _in_data ->> 'report_name')::text,
					'description', (SELECT _in_data ->> 'description')::text,
					'url', (SELECT _in_data ->> 'url')::text,
					'containing_folder_name', (SELECT _in_data ->> 'containing_folder_name')::text,
					'changing_user_login', (SELECT _in_data ->> 'changing_user_login')::text,
					'parameters', (SELECT _in_data -> 'parameters'),
					'insert_or_update', (SELECT _in_data ->> 'insert_or_update')::text
					));
				END IF;	-- parameters were updated successfully			
				
			END IF;
			
		ELSE -- insert_or_update parameter has an invalid value
			_message := (SELECT 'The input parameter insert_or_update has an invalid value, ' || (SELECT _in_data ->> 'insert_or_update')::text || ', nothing can be done.');

			_out_json :=  (SELECT json_build_object(
							'result_indicator', 'Failure',
							'message', _message,
							'report_id', (SELECT _in_data ->> 'report_id')::text,
							'report_name', (SELECT _in_data ->> 'report_name')::text,
							'description', (SELECT _in_data ->> 'description')::text,
							'url', (SELECT _in_data ->> 'url')::text,
							'containing_folder_name', (SELECT _in_data ->> 'containing_folder_name')::text,
							'changing_user_login', (SELECT _in_data ->> 'changing_user_login')::text,
							'parameters', (SELECT _in_data -> 'parameters'),
							'insert_or_update', (SELECT _in_data ->> 'insert_or_update')::text
							));				
		END IF;
		
	END IF;
	
	RETURN _out_json;
	
END;
$$ LANGUAGE plpgsql;		