/* The function


	_in_data:	{
					report_id:
					insert_or_update:	// text allowed values, insert, update
					changing_user_login:
					parameters:	[	]
				}
			
* The json object returned by the function, _out_json, is defined  below.

	_out_json:	{
					result_indicator:
					message:
					report_id:
					insert_or_update:	// text allowed values, insert, update
					changing_user_login:
					parameters:	[	]
				}
				

*/

CREATE OR REPLACE FUNCTION report_manager_schema.action_enter_edit_report_parameters (_in_data json) RETURNS json
AS $$

DECLARE
		
	_out_json json;
	_integer_var	integer;
	
	_insert_or_update	text;
	
	_param_json	json;
	_num_new_params	integer;
	_num_params_changed	boolean;
	_all_params_in_system	boolean;
	_update_params	boolean;
	
	_param_name_json	json;
	_param_name	text;
	_name_not_in_system	text;
	_param_name_changed	boolean;
	
	_parameter_id	uuid;
	_report_id	uuid;
	_message	text;
	
	_num_old_params	integer;
	
	_query_return	text;
	
BEGIN

	_insert_or_update := (SELECT _in_data ->> 'insert_or_update')::text;
	
	--RAISE NOTICE 'report_id = %', (SELECT _in_data ->> 'report_id')::text;
	--_all_params_in_system := TRUE;	-- set to true and then change to FALSE when a param isn't found in the system
	_param_json := (SELECT _in_data -> 'parameters'); 		
	FOR _param_name_json IN SELECT * FROM json_array_elements (_param_json)
	LOOP
		
		_param_name := ((SELECT _param_name_json ->> 'parameter_name')::text);
		_parameter_id	:= (SELECT 
					parameter_id 
				FROM report_manager_schema.parameter_list 
				WHERE parameter_name = _param_name::text
				);
				
		IF _parameter_id IS NULL THEN -- the parameter is not in the system
			_all_params_in_system := FALSE;
			_name_not_in_system := _param_name;
			EXIT;
		END IF;
	
	END LOOP;
	
	IF NOT _all_params_in_system THEN
		_message := (SELECT 'The report parameter named ' || _name_not_in_system::text || ', is not configured in  the system.') ;
		_out_json :=  (SELECT json_build_object(
							'result_indicator', 'Failure',
							'message', _message,
							'report_id', (SELECT _in_data ->> 'report_id')::text,
							'insert_or_update', (SELECT _in_data ->> 'insert_or_update')::text,
							'changing_user_login', (SELECT _in_data ->> 'report_name')::text,
							'parameters', (SELECT _in_data -> 'parameters')::text
							));		
										
	ELSE
		
		IF lower (_insert_or_update) = 'update' THEN	-- if the parameters are changed then delete the paramters and add tne new ones later
		
			_report_id := ((SELECT _in_data ->> 'report_id')::uuid);
			--RAISE NOTICE '_report_id = %', _report_id;
			
		--	don't do anything unless tnhere is a change in the parameters.
		--	a change in parameters can be:
			--	an addition or deletion of one ore more parameters - nubmer of new parameters <> to number of old parameters
			--	one or more parameters are removed and others added - a param name is different

			_param_json := (SELECT _in_data -> 'parameters'); 			
			_num_new_params := (SELECT json_array_length(_param_json));

			-- get an count of current parameters
			_num_old_params :=	(SELECT
									(COUNT (pl.parameter_name))::integer
							FROM	report_manager_schema.parameter_list pl,
									report_manager_schema.reports r,
									report_manager_schema.report_parameters rp
							WHERE	r.report_id = rp.report_id
							  AND	pl.parameter_id = rp.parameter_id
							  AND	rp.report_id = _report_id										
							);

			IF _num_old_params <> _num_new_params THEN	-- there is a change in the parameters
				_num_params_changed := TRUE;
			ELSE	-- the number of params is tne same 
				_num_params_changed := FALSE;
			END IF;
			
			-- check for a change in parameter names			
			_param_name_changed := FALSE;
			FOR _param_name_json IN SELECT * FROM json_array_elements (_param_json)
			LOOP
				
				_param_name := ((SELECT _param_name_json ->> 'parameter_name')::text);

				_parameter_id	:=	(SELECT 
										rp.parameter_id 
									FROM	report_manager_schema.parameter_list pl,
											report_manager_schema.report_parameters rp
									WHERE	pl.parameter_id = rp.parameter_id
									  AND	pl.parameter_name = _param_name::text
									  AND	rp.report_id = _report_id
									);
						
				IF _parameter_id IS NULL THEN -- the parameter name is changed
					_param_name_changed := TRUE;					
					EXIT;	-- we found one change there's no point in looking further
				END IF;
				
			END LOOP;		
				
				
			--RAISE NOTICE '_update_params = %', _update_params;
			IF _num_params_changed OR _param_name_changed THEN -- there are param changes so delete the old ones
				DELETE FROM report_manager_schema.report_parameters WHERE report_id = (SELECT _in_data ->> 'report_id')::uuid;
			END IF;
						
		END IF;

				
		IF lower (_insert_or_update)  = 'insert' OR _num_params_changed OR _param_name_changed  THEN
			
			FOR _param_name_json IN SELECT * FROM json_array_elements (_param_json)
			LOOP
				
				_param_name := ((SELECT _param_name_json ->> 'parameter_name')::text);

				_parameter_id	:= (SELECT 
							parameter_id 
						FROM report_manager_schema.parameter_list 
						WHERE parameter_name = _param_name::text
						);
						
				IF _parameter_id IS NOT NULL THEN 

					INSERT INTO report_manager_schema.report_parameters (
						report_id,
						parameter_id,
						datetime_parameter_added,
						changing_user_login
					)
					VALUES	(
						(SELECT _in_data ->> 'report_id')::uuid,
						_parameter_id,
						LOCALTIMESTAMP (0),
						(SELECT _in_data ->> 'changing_user_login')::text
					);

				END IF;
				
			END LOOP;
			
			IF lower (_insert_or_update)  = 'insert'  THEN
				_message := (SELECT 'The report parameters were added.') ;
			ELSE
				_message := (SELECT 'The report parameters were updated.') ;
			END IF;
			
			_out_json :=  (SELECT json_build_object(
								'result_indicator', 'Success',
								'message', _message,
								'report_id', (SELECT _in_data ->> 'report_id')::text,
								'insert_or_update', (SELECT _in_data ->> 'insert_or_update')::text,
								'changing_user_login', (SELECT _in_data ->> 'report_name')::text,
								'parameters', (SELECT _in_data -> 'parameters')::text
								));						
			

		ELSIF NOT _num_params_changed AND NOT _param_name_changed THEN
		
			_message := (SELECT 'There are no changes to the report parameters.') ;
			_out_json :=  (SELECT json_build_object(
								'result_indicator', 'Success',
								'message', _message,
								'report_id', (SELECT _in_data ->> 'report_id')::text,
								'insert_or_update', (SELECT _in_data ->> 'insert_or_update')::text,
								'changing_user_login', (SELECT _in_data ->> 'report_name')::text,
								'parameters', (SELECT _in_data -> 'parameters')::text
								));					
										
		ELSE	-- the _insert_or_update parameter is neither insert or update
		
			_message := (SELECT 'The submitted _insert_or_update parameter, ' || (SELECT _in_data ->> 'insert_or_update')::text || ', is neither insert or update, please resubmit with a correct value.') ;
			
			_out_json :=  (SELECT json_build_object(
									'result_indicator', 'Failure',
									'message', _message,
									'report_id', (SELECT _in_data ->> 'report_id')::text,
									'insert_or_update', (SELECT _in_data ->> 'insert_or_update')::text,
									'changing_user_login', (SELECT _in_data ->> 'report_name')::text,
									'parameters', (SELECT _in_data -> 'parameters')::text
									));	
		
		END IF;
	
	END IF;
	
	RETURN _out_json;
	
END;
$$ LANGUAGE plpgsql;		