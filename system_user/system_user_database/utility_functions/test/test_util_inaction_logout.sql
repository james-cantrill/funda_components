-- test_util_inaction_logout


DO $$
DECLARE  
	_return_integer	integer;
BEGIN	
	RAISE NOTICE 'util_inaction_logout (3) started';
	_return_integer := (SELECT * FROM system_user_schema.util_inaction_logout (3));
	RAISE NOTICE 'util_inaction_logout (3) ended , _return_integer = % ', _return_integer;
	RAISE NOTICE '';
END$$;
