# Overview of the Funda Components

Funda_components is a set of components which expose microservices for use in creating web applications. Web applications using one or more Funda Components must have a Postgresql database and be implemented using Node js.

Each component will consist of the objects it manages, a schema in the application's database, and an API exposing the component's microservices. The component's functions are implemented as postgresql pgplsql functions in the component's schema in the application's database. These functions will be called only by the component's API module.

The component's API is implemented as a nodejs module. The component's API module defines the action functions as Seneca microservices. (Note the Seneca microservices toolkit is a javascript Node js module used to create message based microservices.) The API microservices invoke a pgplsql function in the component's schema and return the result to the calling application.

The component's schema will include the pgplsql action fuinctions, tables needed to persist the components data model, and any needed utility or other functions.

# Existed and Planned Components

## System User Manager

The System User Manager exposes the actions (functions) needed to authenticate and authorize a system user. This includes managing the permissions needed to use other microservices actions and objects.

###The actions exposed by the System User Manager are:

1. add_new_user
    This action adds a new user to the system

2. user_login
    This action logs the user into the application after authenticating their credentials. All pgplsql functions check to see if a user is logged in before executing.

3. user_logout
    This action logs the user out of the application.

4. change_password
    This action changes a user's password. It checks to see if a user is logged in and that they are authorized top change the password.

5. change_user_allowed_actions
    This action allows a user to change the actions other users are aauthborized to perform. It checks to see if the user is logged in and that they are authorized to change other users' authorizations.

6. list_user_actions
    **This action is not yet implemented.**

## Program or Business Unit Manager

The Program Manager exposes the actions (functions) needed to manage the configuration and visibility programs, organizations, agencies and other business units used in the application.  This component will provide all the actions needed to control the visibility of these agencies, programs, and otnher organizational units to each system user.

###The actions exposed by the Program Manager are:

1. enter_edit_programs
   ** This action is not yet implemented.**

2. list_user_visible_programs
    **This action is not yet implemented.**

3. change_program_user_visibility
    **This action is not yet implemented.**

###Dependencies

The Program Manager depends on the System User Manager

## Report Manager

The Report Manager exposesg the actions (functions) needed to manage the reports available in the application, the parametes needed to run them, and the folders in which they are organized. 

###The actions exposed by the Report Manager are:
1. enter_edit_folders
2. enter_edit_parameters
3. enter_edit_reports
4. enter_edit_report_parameters
5. load_report_list
6. load_run_selected_report
7. enter_edit_allowed_reports

# Using a Funda Component in an Application

