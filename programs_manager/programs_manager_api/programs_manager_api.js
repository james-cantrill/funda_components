"use strict";

// Loading and initializing the library:
var pgp = require('pg-promise')({
    // Initialization Options
});

// Preparing the connection details:
var cn = "postgres://jcantrill:0m!tbdfom5@localhost:5432/report_manager_database";

// Creating a new database instance from the connection details:
var db = pgp(cn);

module.exports = function programs_manager_api( options ) {
	
	var seneca = this;

	var promise = require('bluebird');

	var role_name = 'programs_manager_api'

  // Set top-level options for API
	var options = seneca.util.deepextend({
					promiseLib: promise,
					prefix: '/programs_manager_api/'
					});
	
// Here are the programs_manager_api API definitions

	this.add({role:'programs_manager_api', cmd:'test'}, test);
	
	this.add({role:'programs_manager_api', cmd:'get_one_row'}, get_organizations);
	
	this.add({role:'programs_manager_api', cmd:'list_user_visible_programs'}, list_programs);
	
	this.add({role:'programs_manager_api', cmd:'list_user_visible_organizations'}, list_organizations);
	

	this.add({role:'programs_manager_api', cmd:'change_program_user_visibility'}, change_program_visibility);
	
	this.add({role:'programs_manager_api', cmd:'change_organization_user_visibility'}, change_organization_visibility);

	this.add( {init:'programs_manager_api'}, function init( args, done ) {
		setTimeout( function() {
		  done();
		}, 10000 );
	  }); // END ( {init:'programs_manager_api'}

	

	function test(args, done) {
		done(null, {working:true});
	};
	
	function get_organizations (args, done) {
		var result = db.any("SELECT * FROM programs_manager_schema.organizations", [true])
			.then (function (data) {
				done(null, data);
			})
			.catch (function (error) {
				console.log("ERROR:", error); // print the error;
			});
		
	};

	function list_programs (msg, done) {
		//console.log (msg._in_data);
		var result = db.func('programs_manager_schema.action_list_user_visible_programs_jstree', msg._in_data)
			.then (function (data) {
				done(null, data);
			})
			.catch (function (error) {
				console.log("ERROR:", error); // print the error;
			});
		
	};

	function list_organizations (msg, done) {
		//console.log (msg._in_data);
		var result = db.func('programs_manager_schema.action_list_user_visible_organizations', msg._in_data)
			.then (function (data) {
				done(null, data);
			})
			.catch (function (error) {
				console.log("ERROR:", error); // print the error;
			});
		
	};

	function change_program_visibility (msg, done) {
		console.log (msg._in_data);
		var result = db.func('programs_manager_schema.action_change_program_user_visibility', msg._in_data)
			.then (function (data) {
				done(null, data);
			})
			.catch (function (error) {
				console.log("ERROR:", error); // print the error;
			});
		
	};
	
	function change_organization_visibility (msg, done) {
		//console.log (msg._in_data);
		var result = db.func('programs_manager_schema.action_change_organization_user_visibility', msg._in_data)
			.then (function (data) {
				done(null, data);
			})
			.catch (function (error) {
				console.log("ERROR:", error); // print the error;
			});
		
	};
	

	
	
}; // END module.exports = function programs_manager_api( options )