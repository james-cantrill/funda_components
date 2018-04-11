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

module.exports = function report_manager( options ) {
	
	var seneca = this;

	var promise = require('bluebird');

	var role_name = 'report_manager'

  // Set top-level options for API
	var options = seneca.util.deepextend({
					promiseLib: promise,
					prefix: '/report_manager/'
					});
	
// Here are the report_manager API definitions

	this.add({role:'report_manager', cmd:'load_report_list'}, list_reports);

	this.add({role:'report_manager', cmd:'load_selected_report'}, load_report);

	

	
	this.add( {init:'report_manager'}, function init( args, done ) {
		setTimeout( function() {
		  done();
		}, 10000 );
	  }); // END ( {init:'report_manager'}

	

	function list_reports (msg, done) {
		console.log ('in list_reports');
		console.log (msg._in_data);
		var result = db.func('report_manager_schema.action_load_report_list_jstree', msg._in_data)
			.then (function (data) {
				console.log (data);
				done(null, data);
			})
			.catch (function (error) {
				console.log("ERROR:", error); // print the error;
			});
		
	};

	function load_report (msg, done) {
		console.log (msg._in_data);
		var result = db.func('report_manager_schema.action_load_selected_report', msg._in_data)
			.then (function (data) {
				done(null, data);
			})
			.catch (function (error) {
				console.log("ERROR:", error); // print the error;
			});
		
	};
	
}; // END module.exports = function programs_manager_api( options )