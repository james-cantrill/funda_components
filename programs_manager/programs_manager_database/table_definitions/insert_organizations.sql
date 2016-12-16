
--	insert_organizations.sql

DELETE FROM programs_manager_schema.organizations;

INSERT INTO programs_manager_schema.organizations (organization_id, organization_name, datetime_program_changed, changed_by_user_login) VALUES ('256E115B', 'ACCORD Corporation', LOCALTIMESTAMP (0), 'muser');
INSERT INTO programs_manager_schema.organizations (organization_id, organization_name, datetime_program_changed, changed_by_user_login) VALUES ('B91CC41A', 'Arbor Housing and Development', LOCALTIMESTAMP (0), 'muser');
INSERT INTO programs_manager_schema.organizations (organization_id, organization_name, datetime_program_changed, changed_by_user_login) VALUES ('0A791B9C', 'Catholic Charities of Chemung and Schuyler Counties', LOCALTIMESTAMP (0), 'muser');
INSERT INTO programs_manager_schema.organizations (organization_id, organization_name, datetime_program_changed, changed_by_user_login) VALUES ('A7330F42', 'Catholic Charities of Livingston County', LOCALTIMESTAMP (0), 'muser');
INSERT INTO programs_manager_schema.organizations (organization_id, organization_name, datetime_program_changed, changed_by_user_login) VALUES ('DE1CE153', 'Catholic Charities of Steuben County', LOCALTIMESTAMP (0), 'muser');
INSERT INTO programs_manager_schema.organizations (organization_id, organization_name, datetime_program_changed, changed_by_user_login) VALUES ('AF46063F', 'Catholic Charities of Tompkins/Tioga', LOCALTIMESTAMP (0), 'muser');
INSERT INTO programs_manager_schema.organizations (organization_id, organization_name, datetime_program_changed, changed_by_user_login) VALUES ('6E9033B2', 'Steuben County Department of Social Services (DSS)', LOCALTIMESTAMP (0), 'muser');

SELECT * FROM programs_manager_schema.organizations;