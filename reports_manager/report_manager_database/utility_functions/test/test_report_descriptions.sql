-- test_report_descriptions.sql

DROP TABLE IF EXISTS report_descriptions;

CREATE TEMPORARY TABLE report_descriptions (
	description_json	json
);

INSERT INTO report_descriptions (
	description_json
	)
SELECT
	row_to_json (description_row)
FROM	(SELECT 
			description
		FROM	report_manager_schema.reports
		) description_row
;

SELECT description_json::text FROM report_descriptions;

SELECT description_json FROM report_descriptions;

SELECT description_json ->> 'description' FROM report_descriptions;

