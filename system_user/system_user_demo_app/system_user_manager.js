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

module.exports = function system_user_manager( options ) {
	
	var seneca = this;

	var promise = require('bluebird');

	var role_name = 'system_user_manager'

  // Set top-level options for API
	var options = seneca.util.deepextend({
					promiseLib: promise,
					prefix: '/system_user_manager/'
					});
	
// Here are the system_user_manager API definitions

	this.add({role:'system_user_manager', cmd:'test'}, test);
	
	this.add({role:'system_user_manager', cmd:'get_one_row'}, get_one_row);
	
	this.add({role:'system_user_manager', cmd:'add_one_user'}, function (msg, respond) {

		db.func('system_user_schema.action_add_new_user', msg._in_data)
		.then(function (data) {
			respond (null, data);
		})
		.catch(function (error) {
			console.log("ERROR:", error.message || error); // print the error;
		});
	});

	this.add({role:'system_user_manager', cmd:'user_login'}, function (msg, respond) {
 		//console.log ('In user_login');
		//console.log (msg._in_data);
		db.func('system_user_schema.action_user_login', msg._in_data)
		.then(function (data) {
			//console.log("DATA:", data); // print data;
			respond (null, data);
		})
		.catch(function (error) {
			console.log("ERROR:", error.message || error); // print the error;
		});
	});

//user_logout
	this.add({role:'system_user_manager', cmd:'user_logout'}, function (msg, respond) {
 		db.func('system_user_schema.action_user_logout', msg._in_data)
		.then(function (data) {
			//console.log("DATA:", data); // print data;
			respond (null, data);
		})
		.catch(function (error) {
			console.log("ERROR:", error.message || error); // print the error;
		});
	});

//change_password
	this.add({role:'system_user_manager', cmd:'change_password'}, function (msg, respond) {
 		db.func('system_user_schema.action_change_password', msg._in_data)
		.then(function (data) {
			//console.log("DATA:", data); // print data;
			respond (null, data);
		})
		.catch(function (error) {
			console.log("ERROR:", error.message || error); // print the error;
		});
	});

//change_user_allowed_actions
	this.add({role:'system_user_manager', cmd:'change_user_allowed_actions'}, function (msg, respond) {
 		db.func('system_user_schema.action_change_user_allowed_actions', msg._in_data)
		.then(function (data) {
			//console.log("DATA:", data); // print data;
			respond (null, data);
		})
		.catch(function (error) {
			console.log("ERROR:", error.message || error); // print the error;
		});
	});
	
	this.add( {init:'system_user_manager'}, function init( args, done ) {
		setTimeout( function() {
		  done();
		}, 10000 );
	  }); // END ( {init:'system_user_manager'}

	

	function test(args, done) {
		done(null, {working:true});
	};
	
	function get_one_row (args, done) {
		var result = db.any("SELECT * FROM system_users", [true])
			.then (function (data) {
				done(null, data);
			})
			.catch (function (error) {
				console.log("ERROR:", error); // print the error;
			});
		
	};

/*	function add_one_user (args, done) {
		console.log ('In add_one_user');
		console.log (_in_data);
		db.func('action_add_new_user', [_in_data])
		.then(function (data) {
			console.log("DATA:", data); // print data;
		})
		.catch(function (error) {
			console.log("ERROR:", error.message || error); // print the error;
		});
	};*/
	
	
}; // END module.exports = function system_user_manager( options )