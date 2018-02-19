/* The function action_enter_edit_organizations inserts or updates a record in the organizations table


	_in_data:	
	{
		organization_name:
		organization_description:
		changing_user_login:
	}
			
* The json object returned by the function, _out_json, is defined  below.

	_out_json:	
	{
		result_indicator:
		message:
		organization_name:
		organization_description:
		changing_user_login:
	}
				

*/

CREATE OR REPLACE FUNCTION programs_manager_schema.action_enter_edit_organizations (_in_data json) RETURNS json
AS $$

DECLARE
		
	_out_json json;
	_message	text;
	
	_organization_id	uuid;

	_organization_name	text;
	_organization_description	text;
	_changing_user_login	text;
	

	
--	for calling the system_user_schema.util_is_user_authorized function to determine if the calling user is authorized to add new users
	_calling_login	text;
	_input_authorized_json	json;	-- input json
	_output_authorized_json	json;	-- output json  
	_authorized_result	boolean;
	
	_insert_update_or_error	text;
	
BEGIN

	IF	(SELECT _in_data ->> 'organization_name')::text IS NULL 
		OR (SELECT _in_data ->> 'organization_description')::text IS NULL 
		OR (SELECT _in_data ->> 'changing_user_login')::text IS NULL 
	THEN -- data is incomplete		
		_message := (SELECT 'The data is incomplete as submitted so the Organization Level CAN NOT be entered, please resubmit with complete data.') ;
		_out_json :=  (SELECT json_build_object(
				'result_indicator', 'Failure',
				'message', _message,
				'organization_name', (SELECT _in_data ->> 'organization_name')::text,
				'organization_description',  (SELECT _in_data ->> 'organization_description')::text,
				'changing_user_login', (SELECT _in_data ->> 'changing_user_login')::text
				)
				);
	ELSE
		-- Determine if the calling user is authorized
		_calling_login := (SELECT _in_data ->> 'changing_user_login')::text;
		
		_input_authorized_json :=	(SELECT json_build_object(
								'login', _calling_login,
								'service', 'programs_manager',
								'action', 'action_enter_edit_organizations'
								));
		
		_output_authorized_json := (SELECT * FROM system_user_schema.util_is_user_authorized (_input_authorized_json));
		
		_authorized_result := (SELECT _output_authorized_json ->> 'authorized')::boolean;
		
		IF _authorized_result  THEN

			--does an organization with that name exist, if it doesn't insert the data
			-- if it does update the record
			_organization_id := (	SELECT
								organization_id
							FROM	programs_manager_schema.organizations
							WHERE	organization_name = (SELECT _in_data ->> 'organization_name')::text
							);
							
			IF _organization_id IS NOT NULL THEN	-- a record exists,update it
				_insert_update_or_error := 'update';
			ELSE	-- no record exists, insert one using the in_data
				_insert_update_or_error := 'insert';
			END IF;
			
			IF _insert_update_or_error = 'update' THEN

				UPDATE	programs_manager_schema.organizations
				   SET	organization_name = (SELECT _in_data ->> 'organization_name')::text,
						organization_description = (SELECT _in_data ->> 'organization_description')::text,
						datetime_organization_changed  = LOCALTIMESTAMP (0),
						changing_user_login = (SELECT _in_data ->> 'changing_user_login')::text
				WHERE	organization_id = _organization_id
				;
				
				_message := 'The level named ' || (SELECT _in_data ->> 'organization_name')::text || ' has been updated.';
				
				_out_json :=  (SELECT json_build_object(
									'result_indicator', 'Succees',
									'message', _message,
									'organization_name', (SELECT _in_data ->> 'organization_name')::text,
									'organization_description',  (SELECT _in_data ->> 'organization_description')::text,
									'changing_user_login', _calling_login
									));				
									
			ELSIF _insert_update_or_error = 'insert' THEN
			
				INSERT INTO programs_manager_schema.organizations (
					organization_name,
					organization_description,
					datetime_organization_changed ,
					changing_user_login
					)
				VALUES (
					(SELECT _in_data ->> 'organization_name')::text,
					(SELECT _in_data ->> 'organization_description')::text,
					LOCALTIMESTAMP (0),
					(SELECT _in_data ->> 'changing_user_login')::text
				);				

				_organization_id := (	SELECT
								organization_id
							FROM	programs_manager_schema.organizations
							WHERE	organization_name = (SELECT _in_data ->> 'organization_name')::text
							);
								
				_message := 'The organization named ' || ((SELECT _in_data ->> 'organization_name')::text) || ' has been added.';
				
				_out_json :=  (SELECT json_build_object(
									'result_indicator', 'Success',
									'message', _message,
									'organization_name', (SELECT _in_data ->> 'organization_name')::text,
									'organization_description',  (SELECT _in_data ->> 'organization_description')::text,
									'changing_user_login', _calling_login
									));				
			END IF;	-- IF _insert_update_or_error = 'update' 
			
		ELSE	-- user isn't authorized to enter or edit folders
		
			_message := 'The user ' || _calling_login || ' IS NOT Authorized to enter or edit organizations. Nothng was changed.';
			
			_out_json :=  (SELECT json_build_object(
								'result_indicator', 'Failure',
								'message', _message,
								'organization_level_name', (SELECT _in_data ->> 'organization_level_name')::text,
								'organization_level_display_name', (SELECT _in_data ->> 'organization_level_display_name')::text,
								'organization_level_description',  (SELECT _in_data ->> 'organization_level_description')::text,
								'parent_level_name', (SELECT _in_data ->> 'parent_level_name')::text,
								'changing_user_login', _calling_login
								));	
		END IF;	--IF _authorized_result 
		
	END IF;	-- IF input parameter is missing

	RETURN _out_json;
	
	
END;
$$ LANGUAGE plpgsql;		