
DROP TABLE IF EXISTS system_user_schema.system_users CASCADE;

CREATE TABLE system_user_schema.system_users (
	sysuser_id	uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
	login	text NOT NULL,
	password	text NOT NULL,
	firstname	text NOT NULL,
	lastname	text NOT NULL,
	datetime_user_changed	timestamp without time zone NOT NULL,
	changing_user_login	text NOT NULL,
    CONSTRAINT login_duplicate UNIQUE(login)
);
