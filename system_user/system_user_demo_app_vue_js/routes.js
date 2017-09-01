
var express = require('express');
var router = express.Router();
var user_name;
var _user_login;

var seneca = require('seneca')();
var web = require('seneca-web');
var Promise = require('bluebird');

var act = Promise.promisify(seneca.act,  {context: seneca});
seneca.use( require('./system_user_manager.js') );

router.get('/', function(req, res){  
  res.render('index', {
        data: {
				title: 'Please Log In'
		}
  });
});

router.get('/system_user_manager/user_login', function (req, res) {
	_user_login = req.query.username;
 
	act ({  role:'system_user_manager', 
	        cmd:'user_login', 
			_in_data: {
					login: req.query.username,
					password:  req.query.password
			}
		})
	  .then (function (result) {
		var returned_json = JSON.parse (JSON.stringify (result));
		//console.log('returned_json = ', returned_json);
		var out_data = returned_json[0].action_user_login;
		user_name = out_data.firstname + ' ' + out_data.lastname;
		
		if (out_data.result_indicator == 'Failure') {
			res.render ('home', {
				data: {
					title: out_data.message
				}
			});
		} else {
			res.render ('home', {
				data: {
						name: user_name,
						title: 'Welcome'
				}
					});
		};
		
	  })
	  .catch (function (err) {
		console.log("ERROR:", err); 
		res.send ("ERROR:", err);
	  });

	  
});	//END router.get('/system_user_manager/user_login',

router.get('/enter_user_data', function(req, res){
  res.render('user_data', {
		data:	{
			title: "Enter User Data",
			firstname:	"",
			lastname:	"",
			login:	"",
			Password:	""
		}
  });
});  // end of /enter_user_data

router.get('/system_user_manager/add_one_user', function (req, res) {
	
	act ({  role:'system_user_manager', 
	        cmd:'add_one_user', 
			_in_data: {
					firstname: req.query.firstname,
					lastname: req.query.lastname,
					login: req.query.login,
					password:  req.query.password,
					changing_user_login: _user_login
			}
		})
	  .then(function (result) {
		var returned_json = JSON.parse (JSON.stringify (result));
		var out_data = returned_json[0].action_add_new_user;
		if (out_data.result_indicator == 'Failure') {
			res.render ('home', {
				data: {
					title: out_data.message,
					firstname:	req.query.firstname,
					lastname:	req.query.lastname,
					login:	req.query.login,
					Password:	req.query.password
				}
			});
		} else {
			res.render ('home', {
					data: {
						title: 'User ' + req.query.firstname + ' ' + req.query.lastname + ' is added.'
					}
			});
		};

	  })
	  .catch(function (err) {
		console.log("ERROR:", err); 
		res.send ("ERROR:", err);
	  });
});	//END router.get('/system_user_manager/add_one_user',

router.get('/system_user_manager/list_users', function (req, res) {
	
	act ({  role:'system_user_manager', 
	        cmd:'list_users', 
			_in_data: {
					requesting_user_login: _user_login
			}
		})
	  .then(function (result) {
		var returned_json = JSON.parse (JSON.stringify (result));
		var out_data = returned_json[0].action_list_users;
		
		if (out_data.result_indicator == 'Failure') {
			res.render ('home', {
				data: {
					title: 'Users can not be listed for ' + _user_login
				}
			});
		} else {
			console.log('about to render select_user');
			
			res.render ('select_user', {
					data: {
						title: 'Select One User',
						users:  out_data.users_list
							}
						
			});
		};
	  })
	  .catch(function (err) {
		console.log("ERROR:", err); 
		res.send ("ERROR:", err);
	  });
});	//END router.get('/system_user_manager/list_users'

router.get('/show_user_actions', function(req, res){
	console.log ('Request: ', req.query);
	

	act ({  role:'system_user_manager', 
	        cmd:'list_user_actions', 
			_in_data: {
					user_login: req.query.selected_user,
					requesting_user_login: _user_login
			}
		})
	.then(function (result) {
		var returned_json = JSON.parse (JSON.stringify (result));
		var out_data = returned_json[0].action_list_actions_for_a_user;
		
		if (out_data.result_indicator == 'Failure') {
			res.render ('home', {
				data: {
					title: out_data.message
				}
			});
		} else {
			res.render('edit_user_actions', {
				data:	{
					title: "List of actions for " + out_data.user_login,
					user_actions: out_data.user_actions_list
				}
			});
		}
	})
});  // end of /show_user_actions

///save_user_actions
router.get('/save_user_actions', function (req, res) {
	console.log ('Request: ', req.query);
	
	res.render('home', {
		data:	{
			title: "Return from Edit User Actions " + req.query
		}
  });
  
});
		
		
router.get('/system_user_manager/change_password', function (req, res) {
	
	act ({  role:'system_user_manager', 
	        cmd:'change_password', 
			_in_data: {
					login: req.query.login,
					new_password:  req.query.new_password,
					changing_user_login: _user_login
			}
		})
	  .then(function (result) {
		var returned_json = JSON.parse (JSON.stringify (result));
		var out_data = returned_json[0].change_password;
		
		if (out_data.result_indicator == 'Failure') {
			res.render ('user_data', {
				title: out_data.message,
				login:	req.query.login			});
		} else {
			res.render ('home', {
					data: {
						title: 'User password is changed.'
					}
					});
		};

	  })
	  .catch(function (err) {
		console.log("ERROR:", err); 
		res.send ("ERROR:", err);
	  });
});	//END router.get('/system_user_manager/add_one_user',

router.get('/system_user_manager/user_logout', function (req, res) {
	act ({  role:'system_user_manager', 
	        cmd:'user_logout', 
			_in_data: {
					login: _user_login
			}
		})
	  .then (function (result) {
		var returned_json = JSON.parse (JSON.stringify (result));
		var out_data = returned_json[0].action_user_logout;
		
		if (out_data.result_indicator == 'Failure') {
			res.render ('index', {
					data: {
						name: user_name,
						title: out_data.message
					}
			});
		} else {
			res.render ('index', {
					data: {
						name: user_name,
						title: 'You have successfully Logged Out!'
					}
					});
		};
		
	  })
	  .catch (function (err) {
		console.log("ERROR:", err); 
		res.send ("ERROR:", err);
	  });	  
}); //END router.get('/system_user_manager/user_logout'

 module.exports = router;
