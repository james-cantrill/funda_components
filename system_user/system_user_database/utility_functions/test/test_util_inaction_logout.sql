-- test_system_user_schema.util_inaction_logout

DO $$
DECLARE  
	_return_integer	integer;
BEGIN	
	RAISE NOTICE 'TEST  system_user_schema.util_inaction_logout (30) started';
	RAISE NOTICE '';
	_return_integer := (SELECT * FROM system_user_schema.util_inaction_logout (30));
	RAISE NOTICE 'TEST system_user_schema.util_inaction_logout (30) ended, _return_integer = % ', _return_integer;
	RAISE NOTICE '';
END$$;
