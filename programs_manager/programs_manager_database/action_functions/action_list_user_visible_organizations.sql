/* The function action_list_user_visible_organizations lists all the
* organizations whose data is visible to a given user


	_in_data:	{
					login:
				}
			
* The json object returned by the function, _out_json, is defined  below.

	_out_json:	{
				result_indicator:
				message:
				login:
				organizations: [
						{
							organization_id:
							organization_name:
						}
					]
				}	
				

*/

CREATE OR REPLACE FUNCTION programs_manager_schema.action_list_user_visible_organizations (_in_data json) RETURNS json
AS $$

DECLARE
		
	_out_json json;
	_organizations	json[];
	_login	text;
	_integer_var	integer;
	_message	text;
	
BEGIN

	_login := ((SELECT _in_data ->> 'login')::text);
	
	DROP TABLE IF EXISTS organizations;

	CREATE TEMPORARY TABLE organizations (	
		organization	json
	);
	
	INSERT INTO organizations (
		organization
		)
	SELECT
		row_to_json(organization_row) 
	FROM (	SELECT
				organization_id,
				organization_name
			FROM	programs_manager_schema.system_user_allowed_organizations
			WHERE	login = (SELECT _in_data ->> 'login')::text
			  AND	organization_visible = TRUE 
	  ) organization_row
	;
	
	_organizations := (SELECT ARRAY_AGG(organization) FROM organizations);

	IF _organizations IS NOT NULL THEN
		_message := 'Here is the list of organizations visible to ' || _login || '.';
		
		_out_json :=  (SELECT json_build_object(
									'result_indicator', 'Success',
									'message', _message,
									'login', _login,
									'organizations', _organizations
									));
	ELSE
		_message := 'There are no organizations visible to ' || _login || '.';
		
		_out_json :=  (SELECT json_build_object(
									'result_indicator', 'Failure',
									'message', _message,
									'login', _login,
									'organizations', _organizations
									));	
	END IF;
	RETURN _out_json;
	
	
END;
$$ LANGUAGE plpgsql;		