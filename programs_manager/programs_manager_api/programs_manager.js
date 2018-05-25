"use strict";

//load the application configuration
var app_config = require ('./public/javascript/application_config.js');

// Loading and initializing the library:
var pgp = require('pg-promise')({
    // Initialization Options
});

// Preparing the connection details:
var cn = 'postgres://' + app_config.db_login + ':' + app_config.db_password + '@' + app_config.db_host + ':' + app_config.db_port + '/'  + app_config.database_name;

// Creating a new database instance from the connection details:
var db = pgp(cn);

module.exports = function programs_manager( options ) {
	
	var seneca = this;

	var promise = require('bluebird');

	var role_name = 'programs_manager'

  // Set top-level options for API
	var options = seneca.util.deepextend({
					promiseLib: promise,
					prefix: '/programs_manager/'
					});
	
// Here are the programs_manager API definitions

	this.add({role:'programs_manager', cmd:'list_user_visible_programs'}, list_programs);
	
	this.add( {init:'programs_manager'}, function init( args, done ) {
		setTimeout( function() {
		  done();
		}, 10000 );
	  }); // END ( {init:'programs_manager'}

	

	function list_programs (msg, done) {
		//console.log (msg._in_data);
		var result = db.func('programs_manager_schema.action_load_program_list_vue_jstree', msg._in_data)
			.then (function (data) {
				done(null, data);
			})
			.catch (function (error) {
				console.log("ERROR:", error); // print the error;
			});
		
	};

	
	
}; // END module.exports = function programs_manager( options )