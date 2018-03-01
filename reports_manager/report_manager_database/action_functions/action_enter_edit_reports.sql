-- The function report_manager_schema.action_enter_edit_reports adds a report
-- to the system or updates an existing report ujsing the _in_data json object.

--	_in_data:	{
--					report_id:
--					report_name:
--					description:
--					url:
--					containing_folder_name:
--					insert_or_update:	// text allowed values, insert, update
--					changing_user_login:
--					parameters:	[	]
--				}
			
-- The json object returned by the function, _out_json, is defined  below.

--	_out_json:	{
--					result_indicator:
--					message:
--					report_id:
--					report_name:
--					url:
--					containing_folder_name:
--					insert_or_update:
--					changing_user_login:
--					parameters:	[	]
--				}

CREATE OR REPLACE FUNCTION report_manager_schema.action_enter_edit_reports (_in_data json) RETURNS json
AS $$

DECLARE
	_integer_var	integer;
	_out_json json;
	_message	text;
	_result_indicator	text;
	
	_report_id	uuid;
	_report_name	text;
	_url	text;
	
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
	
	IF _authorized_result  THEN
		-- check if the submitted data is complete
		IF (SELECT _in_data ->> 'report_name')::text IS NULL OR (SELECT _in_data ->> 'description')::text IS NULL OR (SELECT _in_data ->> 'url')::text IS NULL OR (SELECT _in_data ->> 'containing_folder_name')::text IS NULL OR (SELECT _in_data ->> 'changing_user_login')::text IS NULL OR (SELECT _in_data ->> 'insert_or_update')::text IS NULL THEN -- data is incomplete		
			_message := (SELECT 'The data is incomplete as submitted so the report CAN NOT be entered or edited, please resubmit with complete data.') ;
			_result_indicator := 'Failure';
		ELSE	--data is complete so we proceed
			-- does the containing folder exist
			_containing_folder_id :=	(SELECT
						folder_id
					FROM	report_manager_schema.report_folders
					WHERE	folder_name = (SELECT _in_data ->> 'containing_folder_name')::text 
					);
			IF _containing_folder_id IS NULL THEN
				_containing_folder_exists := FALSE;
			ELSE
				_containing_folder_exists := TRUE;
			END IF;
			
			-- is the report name unique
			_report_id	:= (	SELECT 
									report_id 
								FROM report_manager_schema.reports 
								WHERE report_name = (SELECT _in_data ->> 'report_name')::text
								);
			IF _report_id IS NULL THEN
				_report_name_exists := FALSE;
			ELSE
				_report_name_exists := TRUE;
			END IF;
												
			-- is the url unique
			_report_id	:= (	SELECT 
											report_id 
										FROM report_manager_schema.reports 
										WHERE url = (SELECT _in_data ->> 'url')::text
										);	
			IF _report_id IS NULL THEN
				_url_exists := FALSE;
			ELSE
				_url_exists := TRUE;
			END IF;
						
			IF lower ((SELECT _in_data ->> 'insert_or_update')::text) = 'insert' THEN
				IF NOT _containing_folder_exists THEN 
					_message := (SELECT 'The folder with the submitted containing folder name, ' || (SELECT _in_data ->> 'containing_folder_name')::text || ', DOES NOT EXIST so the report CAN NOT be entered, please resubmit with correct data.') ;
					_result_indicator := 'Failure';
				ELSIF _report_name_exists THEN
					_message := (SELECT 'The submitted report name, ' || (SELECT _in_data ->> 'report_name')::text || ', already exists, please choose another.') ;
					_result_indicator := 'Failure';
				ELSIF _url_exists THEN
					_message := (SELECT 'The submitted URL, ' || (SELECT _in_data ->> 'url')::text || ', already exists, please choose another.') ;
					_result_indicator := 'Failure';
				ELSE	-- there is a containing folder and the report name and url are unique so we insert the report and its parameters 
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
						_result_indicator := 'Successs';
					ELSE
						DELETE FROM report_manager_schema.report_parameters WHERE report_id = _report_id;
						DELETE FROM report_manager_schema.reports WHERE report_id = _report_id;
						_message := (SELECT 'There is an error in the parameters ERROR: ' || (SELECT _output_report_param_json ->> 'message')::text || ' Nothing was inserted.');
						_result_indicator := 'Failure';
					END IF;
				END IF;	-- iS there a containing folder and ARE the report name and url unique 
			ELSIF lower ((SELECT _in_data ->> 'insert_or_update')::text) = 'update' THEN	-- update the record
				-- if a report_id is submitted use that to identify the report to be updated if not use the report_name
				IF (SELECT _in_data ->> 'report_id') IS NULL THEN
					_report_id	:= (SELECT 
									report_id 
								FROM report_manager_schema.reports 
								WHERE report_name = (SELECT _in_data ->> 'report_name')::text
								);
				ELSE
					_report_id := ((SELECT _in_data ->> 'report_id')::uuid);
				END IF;
				-- is the containing folder being changed? if so check that it exists before updating
				_old_containing_folder_name := (SELECT 
									containing_folder_name 
								FROM report_manager_schema.reports 
								WHERE report_id = _report_id
								);
				IF _old_containing_folder_name <> (SELECT _in_data ->> 'containing_folder_name')::text AND NOT _containing_folder_exists THEN 
					_containing_folder_name_updateable := FALSE;
				ELSE
					_containing_folder_name_updateable := TRUE;
				END IF;
				-- is the report name being changed? if so check that it exists before updating
				-- don't update if the report name already exists
				_old_report_name := (SELECT 
									report_name 
								FROM report_manager_schema.reports 
								WHERE report_id = _report_id
								);
				IF _old_report_name <> (SELECT _in_data ->> 'report_name')::text AND  _report_name_exists THEN 
					_report_name_updateable := FALSE;
				ELSE
					_report_name_updateable := TRUE;
				END IF;
				-- is the url being changed? if so check that it exists before updating
				-- don't update if the url already exists
				_old_url := (SELECT 
									url 
								FROM report_manager_schema.reports 
								WHERE report_id = _report_id
								);
				IF _old_url <> (SELECT _in_data ->> 'url')::text AND  _url_exists THEN 
					_url_updateable := FALSE;
				ELSE
					_url_updateable := TRUE;
				END IF;
				
				IF NOT _containing_folder_name_updateable THEN
					_message := (SELECT 'The folder with the submitted containing folder name, ' || (SELECT _in_data ->> 'containing_folder_name')::text || ', DOES NOT EXIST so the report CAN NOT be updated, please resubmit with correct data.') ;
					_result_indicator := 'Failure';
				ELSIF NOT _report_name_updateable THEN
					_message := (SELECT 'The submitted report name, ' || (SELECT _in_data ->> 'report_name')::text || ', already exists and the report CANNOT be updated, please choose another.') ;
					_result_indicator := 'Failure';
				ELSIF NOT _url_updateable THEN
					_message := (SELECT 'The submitted URL, ' || (SELECT _in_data ->> 'url')::text || ', already exists  and the report CANNOT be updated, please choose another.') ;
					 _result_indicator := 'Failure';
				ELSE	-- there is a containing folder and the report name and url are unique so we update the report and its parameters 			
					--	before updating the reports table update the parameters and only update reports if the parameters were successfuly updated
					_input_report_param_json :=  (SELECT json_build_object(
										'report_id', _report_id,
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
						WHERE	report_id = _report_id	
						;								
						_message := (SELECT 'The report ' || (SELECT _in_data ->> 'report_name')::text || ' has been updated.');
						_result_indicator := 'Successs'; 
					ELSE
						_message := (SELECT 'There is an error in the parameters ERROR: ' || (SELECT _output_report_param_json ->> 'message')::text || ' Nothing was updated.');
						_result_indicator := 'Failure';
					END IF;	-- parameters were updated successfully							
				END IF;	--IF NOT _containing_folder_exists 
			ELSE	-- the _insert_or_update parameter is neither insert or update
				_message := (SELECT 'The submitted _insert_or_update parameter, ' || (SELECT _in_data ->> 'insert_or_update')::text || ', is neither insert or update, please resubmit with a correct value.') ;
				_result_indicator := 'Failure';
			END IF;	-- IF lower (_insert_or_update)
		END IF;	-- check if the submitted data is complete
	ELSE	-- user isn't authorized to enter or edit reports
		_message := 'The user ' || _calling_login || ' IS NOT Authorized to en ter or edit reports. Nothng was changed.';
		_result_indicator := 'Failure';
	END IF;
	_out_json :=  (SELECT json_build_object(
						'result_indicator', _result_indicator,
						'message', _message,
						'report_name', (SELECT _in_data ->> 'report_name')::text,
						'url', (SELECT _in_data ->> 'url')::text,
						'containing_folder_name', (SELECT _in_data ->> 'containing_folder_name')::text,
						'insert_or_update', (SELECT _in_data ->> 'insert_or_update')::text, 
						'changing_user_login', (SELECT _in_data ->> 'changing_user_login')::text,
						'parameters', (SELECT _in_data -> 'parameters')
						));	
	RETURN _out_json;
	
END;
$$ LANGUAGE plpgsql;		