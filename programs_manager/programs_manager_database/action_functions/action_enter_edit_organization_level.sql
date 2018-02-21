/* The function action_enter_edit_organization_level inserts or updates a record in the organization_level table


	_in_data:	
	{
		organization_level_id:
		organization_level_name:
		organization_level_display_name:
		organization_level_description:
		parent_level_id:  
		is_root_level:	-- boolean
		organization_id:
		changing_user_login:
		enter_or_update:
	}
			
* The json object returned by the function, _out_json, is defined  below.

	_out_json:	
	{
		result_indicator:
		message:
		organization_level_id:
		organization_level_name:
		organization_level_display_name:
		organization_level_description:
		parent_level_id:
		is_root_level:
		organization_id:
		changing_user_login:
		enter_or_update:
	}
				

*/

CREATE OR REPLACE FUNCTION programs_manager_schema.action_enter_edit_organization_level (_in_data json) RETURNS json
AS $$

DECLARE
		
	_out_json json;
	_message	text;
	_organization_level_id	uuid;

	_parent_level_id	uuid;
	_parent_level_name	text;
	_parent_level_exists	boolean;
	_is_root	boolean ;
	
	_organization_id	uuid;
	_organization_level_name	text;
	
--	for calling the system_user_schema.util_is_user_authorized function to determine if the calling user is authorized to add new users
	_calling_login	text;
	_input_authorized_json	json;	-- input json
	_output_authorized_json	json;	-- output json  
	_authorized_result	boolean;
	
	_enter_update	text;
	
BEGIN

	-- Determine if the calling user is authorized ---------------------------
	_calling_login := (SELECT _in_data ->> 'changing_user_login')::text;
	
	_input_authorized_json :=	(SELECT json_build_object(
							'login', _calling_login,
							'service', 'programs_manager',
							'action', 'enter_edit_organization_level'
							));
	
	_output_authorized_json := (SELECT * FROM system_user_schema.util_is_user_authorized (_input_authorized_json));
	
	_authorized_result := (SELECT _output_authorized_json ->> 'authorized')::boolean;

------------ check that the parent level exists ------------------------------
	_parent_level_name := (SELECT _in_data ->> 'parent_level_name')::text;
	_is_root := (SELECT _in_data ->> 'is_root_level')::BOOLEAN;

	IF _parent_level_name IS NOT NULL AND NOT _is_root THEN
		_parent_level_id :=	(SELECT
									organization_level_id
								FROM	programs_manager_schema.organization_level
								WHERE	organization_level_name = _parent_level_name 
								);
		IF _parent_level_id IS NOT NULL THEN
			_parent_level_exists := TRUE;
		ELSE
			_parent_level_exists := FALSE;
		END IF;
	ELSIF _is_root THEN	--  this is a root folder
			_parent_level_exists := TRUE; 
	ELSE	-- there is no parent level name
			_parent_level_exists := FALSE;
	END IF;
	
------------ check that the organization exists ------------------------------
	_organization_id := (	SELECT
						organization_id
					FROM	programs_manager_schema.organizations
					WHERE	organization_name = (SELECT _in_data ->> 'organization_name')::text
					);
			
------------------------------------------------------------------------------
	IF	(SELECT _in_data ->> 'organization_level_name')::text IS NULL 
		OR (SELECT _in_data ->> 'organization_level_display_name')::text IS NULL 
		OR (SELECT _in_data ->> 'organization_level_description')::text IS NULL 
		OR (SELECT _in_data ->> 'is_root_level')::text IS NULL  
		OR ((SELECT _in_data ->> 'is_root_level')::BOOLEAN = FALSE
			AND (SELECT _in_data ->> 'parent_level_name')::text IS NULL)
		OR (SELECT _in_data ->> 'organization_name')::text IS NULL  
		OR (SELECT _in_data ->> 'changing_user_login')::text IS NULL 
		OR (SELECT _in_data ->> 'enter_or_update')::text IS NULL 
		OR ((SELECT _in_data ->> 'enter_or_update')::text = 'Update'
			AND (SELECT _in_data ->> 'organization_level_id')::text IS NULL)
	THEN -- data is incomplete		
		_message := (SELECT 'The data is incomplete as submitted so the Organization Level CAN NOT be entered, please resubmit with complete data.') ;
		_out_json :=  (SELECT json_build_object(
				'result_indicator', 'Failure',
				'message', _message,
				'organization_level_id', (SELECT _in_data ->> 'organization_level_id')::text,
				'organization_level_name', (SELECT _in_data ->> 'organization_level_name')::text,
				'organization_level_display_name', (SELECT _in_data ->> 'organization_level_display_name')::text,
				'organization_level_description',  (SELECT _in_data ->> 'organization_level_description')::text,
				'parent_level_name', (SELECT _in_data ->> 'parent_level_name')::text,
				'is_root_level', (SELECT _in_data ->> 'is_root_level')::text,
				'organization_name', (SELECT _in_data ->> 'organization_name')::text,
				'changing_user_login', (SELECT _in_data ->> 'changing_user_login')::text,
				'enter_or_update', (SELECT _in_data ->> 'enter_or_update')::text
				)
			);
				
	ELSIF NOT _authorized_result  THEN
		_message := 'The user ' || _calling_login || ' IS NOT Authorized to enter or edit organization levels. Nothng was changed.';
		
		_out_json :=  (SELECT json_build_object(
							'result_indicator', 'Failure',
							'message', _message,
							'organization_level_id', (SELECT _in_data ->> 'organization_level_id')::text,
							'organization_level_name', (SELECT _in_data ->> 'organization_level_name')::text,
							'organization_level_display_name', (SELECT _in_data ->> 'organization_level_display_name')::text,
							'organization_level_description',  (SELECT _in_data ->> 'organization_level_description')::text,
							'parent_level_name', (SELECT _in_data ->> 'parent_level_name')::text,
							'is_root_level', (SELECT _in_data ->> 'is_root_level')::text,
							'organization_name', (SELECT _in_data ->> 'organization_name')::text,
							'changing_user_login', _calling_login,
				'			enter_or_update', (SELECT _in_data ->> 'enter_or_update')::text
							));			-- 	log user NOT authorized error
							
	ELSIF NOT _parent_level_exists THEN   -- parent level DOESN'T exist
		_message := (SELECT 'The specified parent organizational level ' || || ' does not exist so the Organization Level CAN NOT be entered.') ;
		_out_json :=  (SELECT json_build_object(
				'result_indicator', 'Failure',
				'message', _message,
				'organization_level_id', (SELECT _in_data ->> 'organization_level_id')::text,
				'organization_level_name', (SELECT _in_data ->> 'organization_level_name')::text,
				'organization_level_display_name', (SELECT _in_data ->> 'organization_level_display_name')::text,
				'organization_level_description',  (SELECT _in_data ->> 'organization_level_description')::text,
				'parent_level_name', (SELECT _in_data ->> 'parent_level_name')::text,
				'is_root_level', (SELECT _in_data ->> 'is_root_level')::text,
				'organization_name', (SELECT _in_data ->> 'organization_name')::text,
				'changing_user_login', (SELECT _in_data ->> 'changing_user_login')::text,
				'enter_or_update', (SELECT _in_data ->> 'enter_or_update')::text
				)
			);
				

	ELSIF _organization_id IS NULL THEN	-- organization DOESN'T exist
	
		_message := (SELECT 'The specified organization ' || (SELECT _in_data ->> 'organization_name')::text || ' does not exist so the Organizational Level CAN NOT be entered.') ;
		_out_json :=  (SELECT json_build_object(
				'result_indicator', 'Failure',
				'message', _message,
				'organization_level_id', (SELECT _in_data ->> 'organization_level_id')::text,
				'organization_level_name', (SELECT _in_data ->> 'organization_level_name')::text,
				'organization_level_display_name', (SELECT _in_data ->> 'organization_level_display_name')::text,
				'organization_level_description',  (SELECT _in_data ->> 'organization_level_description')::text,
				'parent_level_name', (SELECT _in_data ->> 'parent_level_name')::text,
				'is_root_level', (SELECT _in_data ->> 'is_root_level')::text,
				'organization_name', (SELECT _in_data ->> 'organization_name')::text,
				'changing_user_login', (SELECT _in_data ->> 'changing_user_login')::text,
				'enter_or_update', (SELECT _in_data ->> 'enter_or_update')::text
				)
			);
				
	ELSE
		_enter_update := (SELECT _in_data ->> 'enter_or_update')::text;
		
		IF _enter_update = 'Enter' THEN 
		
		------------ check that the organization_level exists ------------------------
		_organization_level_id := (	SELECT
							organization_level_id
						FROM	programs_manager_schema.organization_level
						WHERE	organization_level_name = (SELECT _in_data ->> 'organization_level_name')::text
						);
						
			IF _organization_level_id IS NOT NULL THEN  -- name exists
				_message := (SELECT  'An organizational level with the name ' || (SELECT _in_data ->> 'organization_level_name')::text || ' exists so this organizational level CAN NOT be entered, please resubmit with a different name.') ;
				_out_json :=  (SELECT json_build_object(
						'result_indicator', 'Failure',
						'message', _message,
						'organization_level_id', (SELECT _in_data ->> 'organization_level_id')::text,
						'organization_level_name', (SELECT _in_data ->> 'organization_level_name')::text,
						'organization_level_display_name', (SELECT _in_data ->> 'organization_level_display_name')::text,
						'organization_level_description',  (SELECT _in_data ->> 'organization_level_description')::text,
						'parent_level_name', (SELECT _in_data ->> 'parent_level_name')::text,
						'is_root_level', (SELECT _in_data ->> 'is_root_level')::text,
						'organization_name', (SELECT _in_data ->> 'organization_name')::text,
						'changing_user_login', (SELECT _in_data ->> 'changing_user_login')::text,
						'enter_or_update', (SELECT _in_data ->> 'enter_or_update')::text
						)
					);
			ELSE
				INSERT INTO programs_manager_schema.organization_level (
					organization_level_name,
					organization_level_display_name,
					organization_level_description,
					parent_level_id,
					is_root_level,
					organization_id,
					datetime_level_changed ,
					changing_user_login
					)
				VALUES (
					(SELECT _in_data ->> 'organization_level_name')::text,
					(SELECT _in_data ->> 'organization_level_display_name')::text,
					(SELECT _in_data ->> 'organization_level_description')::text,
					_parent_level_id,
					(SELECT _in_data ->> 'is_root_level')::BOOLEAN,
					_organization_id,
					LOCALTIMESTAMP (0),
					(SELECT _in_data ->> 'changing_user_login')::text
				);				

				_organization_level_id := (	SELECT
									organization_level_id
								FROM	programs_manager_schema.organization_level
								WHERE	organization_level_name = (SELECT _in_data ->> 'organization_level_name')::text
								);	
								
				_message := 'The level named ' || (SELECT _in_data ->> 'organization_level_name')::text || ' has been added.';
				_out_json :=  (SELECT json_build_object(
						'result_indicator', 'Success',
						'message', _message,
						'organization_level_id', _organization_level_id::text,
						'organization_level_name', (SELECT _in_data ->> 'organization_level_name')::text,
						'organization_level_display_name', (SELECT _in_data ->> 'organization_level_display_name')::text,
						'organization_level_description',  (SELECT _in_data ->> 'organization_level_description')::text,
						'parent_level_name', (SELECT _in_data ->> 'parent_level_name')::text,
						'is_root_level', (SELECT _in_data ->> 'is_root_level')::text,
						'organization_name', (SELECT _in_data ->> 'organization_name')::text,
						'changing_user_login', (SELECT _in_data ->> 'changing_user_login')::text,
						'enter_or_update', (SELECT _in_data ->> 'enter_or_update')::text
						)
					);	
			END IF;
			
		ELSIF _enter_update = 'Update' THEN 
		
			_organization_level_name := (	SELECT
						organization_level_name
					FROM	programs_manager_schema.organization_level
					WHERE	organization_level_id = (SELECT _in_data ->> 'organization_level_id')::uuid
					);
		
			IF _organization_level_name IS NULL THEN  -- name DOESN'T exist
			
				_message := (SELECT  'No organizational level with the organization_level_id ' || (SELECT _in_data ->> 'organization_level_id')::text || ' exists  so this update CAN NOT be completed, please resubmit with different data.') ;
				_out_json :=  (SELECT json_build_object(
						'result_indicator', 'Failure',
						'message', _message,
						'organization_level_name', (SELECT _in_data ->> 'organization_level_name')::text,
						'organization_level_display_name', (SELECT _in_data ->> 'organization_level_display_name')::text,
						'organization_level_description',  (SELECT _in_data ->> 'organization_level_description')::text,
						'parent_level_name', (SELECT _in_data ->> 'parent_level_name')::text,
						'is_root_level', (SELECT _in_data ->> 'is_root_level')::text,
						'organization_name', (SELECT _in_data ->> 'organization_name')::text,
						'changing_user_login', (SELECT _in_data ->> 'changing_user_login')::text,
						'enter_or_update', (SELECT _in_data ->> 'enter_or_update')::text
						)
					);
					
			ELSE
			
				UPDATE	programs_manager_schema.organization_level
				   SET	organization_level_name = (SELECT _in_data ->> 'organization_level_name')::text,
						organization_level_display_name = (SELECT _in_data ->> 'organization_level_display_name')::text,
						organization_level_description = (SELECT _in_data ->> 'organization_level_description')::text,
						parent_level_id = _parent_level_id,
						is_root_level = (SELECT _in_data ->> 'is_root_level')::BOOLEAN,
						organization_id = _organization_id,
						datetime_level_changed  = LOCALTIMESTAMP (0),
						changing_user_login = (SELECT _in_data ->> 'changing_user_login')::text
				WHERE	organization_level_id = (SELECT _in_data ->> 'organization_level_id')::uuid
				;
				
				_message := 'The level with the organization_level_id ' || (SELECT _in_data ->> 'organization_level_id')::text || ' has been updated.';
				
				_out_json :=  (SELECT json_build_object(
									'result_indicator', 'Succees',
									'message', _message,
									'organization_level_id', _organization_level_id,
									'organization_level_name', (SELECT _in_data ->> 'organization_level_name')::text,
									'organization_level_display_name', (SELECT _in_data ->> 'organization_level_display_name')::text,
									'organization_level_description',  (SELECT _in_data ->> 'organization_level_description')::text,
									'parent_level_name', (SELECT _in_data ->> 'parent_level_name')::text,
									'is_root_level', (SELECT _in_data ->> 'is_root_level')::text,
									'organization_name', (SELECT _in_data ->> 'organization_name')::text,
									'changing_user_login', _calling_login
									));				
			END IF;
			
		ELSE --  enter_or_update has an invalid value log an error
		
			_message := (SELECT 'The input parameter enter_or_update has an invalid value, ' || (SELECT _in_data ->> 'enter_or_update')::text || ', nothing can be done.');
			
			_out_json :=  (SELECT json_build_object(
					'result_indicator', 'Failure',
					'message', _message,
					'organization_level_id', (SELECT _in_data ->> 'organization_level_id')::text,
					'organization_level_name', (SELECT _in_data ->> 'organization_level_name')::text,
					'organization_level_display_name', (SELECT _in_data ->> 'organization_level_display_name')::text,
					'organization_level_description',  (SELECT _in_data ->> 'organization_level_description')::text,
					'parent_level_name', (SELECT _in_data ->> 'parent_level_name')::text,
					'is_root_level', (SELECT _in_data ->> 'is_root_level')::text,
					'organization_name', (SELECT _in_data ->> 'organization_name')::text,
					'changing_user_login', (SELECT _in_data ->> 'changing_user_login')::text,
					'enter_or_update', (SELECT _in_data ->> 'enter_or_update')::text
					)
				);		
		END IF;    -- _enter_update = 'Enter' 
		
	END IF;		
		


	RETURN _out_json;
	
	
END;
$$ LANGUAGE plpgsql;		