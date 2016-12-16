--	test_pop_allowed_programs.sql

--	Log in Roger Fitzroger opal

DROP TABLE IF EXISTS allowed_programs_data;

CREATE TEMPORARY TABLE allowed_programs_data (
	node_type	text,
	id	text,
	parent	text,
	text	text
);

--	List programs visible to Roger Fitzroger, opal
SELECT * FROM programs_manager_schema.pop_allowed_programs ('opal');

SELECT * FROM allowed_programs_data;

TRUNCATE TABLE allowed_programs_data;
