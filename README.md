# Overview of the Funda Components

Funda_components is a set of components which expose microservices for use in creating web applications. Web applications using one or more Funda Components must have a Postgresql database and be implemented using Node js.

Each component will consist of the objects it manages, a schema in the application's database, and an API exposing the component's microservices. The component's functions are implemented as postgresql pgplsql functions in the component's schema in the application's database. These functions will be called only by the component's API module.

The component's API is implemented as a nodejs module. The component's API module defines the action functions as Seneca microservices. (Note the Seneca microservices toolkit is a javascript Node js module used to create message based microservices.) The API microservices invoke a pgplsql function in the component's schema and return the result to the calling application.

The component's schema will include the pgplsql action fuinctions, tables needed to persist the components data model, and any needed utility or other functions.

# Existed and Planned Components

## System User Manager

The System User Manager exposes the actions (functions) needed to authenticate and authorize a system user. This includes managing the permissions needed to use other microservices actions and objects.

The actions exposed by the System User Manager are:

1. add_new_user
2. user_login
3. user_logout
4. change_password
5. change_user_allowed_actions
6. list_user_actions

## Program or Business Unit Manager

## Report Manager

# Using a Funda Component in an Application

