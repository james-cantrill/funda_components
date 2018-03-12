
var express = require('express');
var router = express.Router();
var user_name;
var user_login;

var seneca = require('seneca')();
var web = require('seneca-web');
var Promise = require('bluebird');

var act = Promise.promisify(seneca.act,  {context: seneca});
seneca.use( require('./system_user_manager.js') );

router.get('/', function(req, res){  
  res.render('index', {
        title: 'Please Log In'
  });
});

router.get('/system_user_manager/user_login', function (req, res) {
	user_login = req.query.login;
	console.log (req.query);
	act ({  role:'system_user_manager', 
	        cmd:'user_login', 
			_in_data: {
					login: req.query.login,
					password:  req.query.password
			}
		})
	  .then (function (result) {
		var returned_json = JSON.parse (JSON.stringify (result));
		var out_data = returned_json[0].action_user_login;
		user_name = out_data.firstname + ' ' + out_data.lastname;
		
		if (out_data.result_indicator == 'Failure') {
			res.render ('index', {
				title: out_data.message
			});
		} else {
			res.render ('home', {
						name: user_name,
						title: 'Welcome'
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
        title: "Enter User Data",
		firstname:	"",
		lastname:	"",
		login:	"",
		Password:	""
  });
});  // end of /enter_unsheltered

router.get('/system_user_manager/add_one_user', function (req, res) {
	
	act ({  role:'system_user_manager', 
	        cmd:'add_one_user', 
			_in_data: {
					firstname: req.query.firstname,
					lastname: req.query.lastname,
					login: req.query.login,
					password:  req.query.password,
					changing_user_login: user_login
			}
		})
	  .then(function (result) {
		var returned_json = JSON.parse (JSON.stringify (result));
		var out_data = returned_json[0].action_add_new_user;
		
		if (out_data.result_indicator == 'Failure') {
			res.render ('user_data', {
				title: out_data.message,
				firstname:	req.query.firstname,
				lastname:	req.query.lastname,
				login:	req.query.login,
				Password:	req.query.password
			});
		} else {
			res.render ('home', {
						title: 'User ' + req.query.firstname + ' ' + req.query.lastname + ' is added.'
					});
		};

	  })
	  .catch(function (err) {
		console.log("ERROR:", err); 
		res.send ("ERROR:", err);
	  });
});	//END router.get('/system_user_manager/add_one_user',

router.get('/system_user_manager/change_password', function (req, res) {
	
	act ({  role:'system_user_manager', 
	        cmd:'change_password', 
			_in_data: {
					login: req.query.login,
					new_password:  req.query.new_password,
					changing_user_login: user_login
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
						title: 'User password is changed.'
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
					login: user_login
			}
		})
	  .then (function (result) {
		var returned_json = JSON.parse (JSON.stringify (result));
		var out_data = returned_json[0].action_user_logout;
		
		if (out_data.result_indicator == 'Failure') {
			res.render ('index', {
						name: user_name,
						title: out_data.message
			});
		} else {
			res.render ('index', {
						name: user_name,
						title: 'You have successfully Logged Out!'
					});
		};
		
	  })
	  .catch (function (err) {
		console.log("ERROR:", err); 
		res.send ("ERROR:", err);
	  });	  
}); //END router.get('/system_user_manager/user_logout'

 module.exports = router;
