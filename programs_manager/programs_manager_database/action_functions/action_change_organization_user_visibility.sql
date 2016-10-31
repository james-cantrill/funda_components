/* The function change_organization_user_visibility


	_in_data:	{
					login:
					service:
					organization_name:
					task:	//visible (set programs_manager_schema.system_user_allowed_organizations.organization_visible to TRUE) or not_visible (set programs_manager_schema.system_user_allowed_organizations.organization_visible to FALSE)
					changing_user_login:
				}
			
* The json object returned by the function, _out_json, is defined  below.

	_out_json:	{
				result_indicator:
				message:
				login:
				service:
				organization_id:
				organization_name:
				visible:
				changing_user_login:
				}
				

*/

CREATE OR REPLACE FUNCTION programs_manager_schema.action_change_organization_user_visibility (_in_data json) RETURNS json
AS $$

DECLARE
		
	_out_json json;
	_message	text;
	_organization_visible	boolean;	
	_service	text;
	_organization	text;
	_organization_id	text;
	_submited_login	text;
	_sysuser_id	uuid;
	
	_firstname	text;
	_lastname	text;
	
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
							'service', 'programs_manager',
							'action', 'change_organization_user_visibility'
							));
	
	_output_authorized_json := (SELECT * FROM system_user_schema.util_is_user_authorized (_input_authorized_json));
	
	_authorized_result := (SELECT _output_authorized_json ->> 'authorized')::boolean;
	
	_submited_login := (SELECT lower ((SELECT _in_data ->> 'login')));
		
	_firstname := (SELECT firstname FROM system_user_schema.system_users WHERE login = _submited_login);
	_lastname := (SELECT lastname FROM system_user_schema.system_users WHERE login = _submited_login);
			
	IF _authorized_result  THEN
	
		_service := (SELECT _in_data ->> 'service')::text;
		_organization := (SELECT _in_data ->> 'organization_name')::text;
		
		_organization_id := (	SELECT 
								organization_id 
							FROM programs_manager_schema.system_user_allowed_organizations
							WHERE login = _submited_login
							  AND  organization_name = _organization
							);
							
		IF _organization_id IS NOT NULL THEN	-- the user already has an entry for this organization and we can change it
		
			_organization_visible := (SELECT
										organization_visible
									FROM	programs_manager_schema.system_user_allowed_organizations
									WHERE	 login = _submited_login
									  AND	organization_id = _organization_id
								);
								
			IF (SELECT _in_data ->> 'task')::text = 'visible'  AND _organization_visible = FALSE THEN
			
				_organization_visible := TRUE;
				
				UPDATE	programs_manager_schema.system_user_allowed_organizations
				   SET	organization_visible = TRUE,
						datetime_organization_visibility_changed = LOCALTIMESTAMP (0)
				WHERE	login = _submited_login
				  AND	organization_id = _organization_id
				;
			
				_message := (SELECT 'The organization ' || _organization || ' is now visible to ' ||  _firstname || ' ' || _lastname );
			
			
				_out_json :=  (SELECT json_build_object(
								'result_indicator', 'Success',
								'message', _message,
								'login', _submited_login,
								'service', _service,
								'organization_id', _organization_id,
								'organization_name', _organization,
								'visible', _organization_visible,
								'changing_user_login', _calling_login
								));
								
			ELSIF (SELECT _in_data ->> 'task')::text = 'visible'  AND _organization_visible = TRUE THEN
			
				_message := (SELECT 'The program ' || _organization || ' is already visible to ' ||  _firstname || ' ' || _lastname || '. Nothing will be done.' );
			
				 _out_json :=  (SELECT json_build_object(
								'result_indicator', 'Failure',
								'message', _message,
								'login', _submited_login,
								'service', _service,
								'organization_id', _organization_id,
								'organization_name', _organization,
								'visible', _organization_visible,
								'changing_user_login', _calling_login
									));
										
			ELSIF (SELECT _in_data ->> 'task')::text = 'not_visible'  AND _organization_visible = TRUE THEN
			
				_organization_visible := FALSE;
				
				UPDATE	programs_manager_schema.system_user_allowed_organizations
				   SET	organization_visible = FALSE,
						datetime_organization_visibility_changed = LOCALTIMESTAMP (0)
				WHERE	login = _submited_login
				  AND	organization_id = _organization_id
				;

				_message := (SELECT 'The program ' || _organization || ' is no longer visible to ' ||  _firstname || ' ' || _lastname );
			
				_out_json :=  (SELECT json_build_object(
									'result_indicator', 'Success',
									'message', _message,
									'login', _submited_login,
									'service', _service,
									'organization_id', _organization_id,
									'organization_name', _organization,
									'visible', _organization_visible,
									'changing_user_login', _calling_login
									));
			
			ELSE
			
				_message := (SELECT 'The program ' || _organization || ' is already inaccessible to ' ||  _firstname || ' ' || _lastname || '. Nothing will be done.' );
			
				 _out_json :=  (SELECT json_build_object(
								'result_indicator', 'Failure',
								'message', _message,
								'login', _submited_login,
								'service', _service,
								'organization_id', _organization_id,
								'organization_name', _organization,
								'visible', _organization_visible,
								'changing_user_login', _calling_login
									));
			END IF;

		ELSE	-- IF _organization_id IS NOT NULL THEN	-- the user does not have an entry for this organiztion so we add it
		
			_organization := (SELECT _in_data ->> 'organization_name')::text;
			RAISE NOTICE '_organization = %', _organization;
			
			_sysuser_id := (	SELECT 
									sysuser_id 
								FROM system_user_schema.system_users 
								WHERE login = lower ((SELECT _in_data ->> 'login'))
								);
							
			_organization_id := (	SELECT 
									organization_id 
								FROM programs_manager_schema.organizations
								WHERE organization_name = _organization
								);

			INSERT INTO programs_manager_schema.system_user_allowed_organizations (
				sysuser_id,
				login,
				organization_id,
				organization_name,
				organization_visible,
				datetime_organization_visibility_changed,
				changed_by_user_login
				)
			SELECT
				_sysuser_id,
				_submited_login,
				_organization_id,
				_organization,
				TRUE,
				LOCALTIMESTAMP (0),
				_calling_login
			;
			
			_message := (SELECT 'The program ' || _organization || ' is now visible to ' ||  _firstname || ' ' || _lastname );
			
			_out_json :=  (SELECT json_build_object(
								'result_indicator', 'Success',
								'message', _message,
								'login', _submited_login,
								'service', _service,
								'organization_id', _organization_id,
								'organization_name', _organization,
								'visible', TRUE,
								'changing_user_login', _calling_login
								));

		END IF;
		
	ELSE	--	the calling user is not authorized to change program accesiblilty
		_message := 'The user ' || _calling_login || ' IS NOT Authorized to change users'' organization visibility. Nothng was changed.';
		
		_out_json :=  (SELECT json_build_object(
							'result_indicator', 'Failure',
							'message', _message,
							'login', (SELECT _in_data ->> 'login')::text,
							'service', (SELECT _in_data ->> 'service')::text,
							'organization_name',  (SELECT _in_data ->> 'program')::text,
							'changing_user_login', _calling_login
							));	
	END IF;
	RETURN _out_json;
	
	
END;
$$ LANGUAGE plpgsql;		
