
var express = require('express');
var router = express.Router();
var user_name;
var user_login;

var seneca = require('seneca')();
var Promise = require('bluebird');

const Cors = require("cors");

router.use(Cors());

var act = Promise.promisify(seneca.act,  {context: seneca});
seneca.use( require('./system_user_manager.js') );

router.get('/', function(req, res){  
  res.json({'response': 'made api contact'});
});

router.get('/system_user_manager/user_login', function (req, res) {
	user_login = req.query.login;
	//console.log (req.query);
	act ({  role:'system_user_manager', 
	        cmd:'user_login', 
			_in_data: {
					'login': req.query.login,
					'password':  req.query.password
			}
		})
	  .then (function (result) {
		var returned_json = JSON.parse (JSON.stringify (result));
		var out_data = returned_json[0].action_user_login;
		user_name = out_data.firstname + ' ' + out_data.lastname;
		
		res.send (out_data);
		
	  })
	  .catch (function (err) {
		console.log("ERROR:", err); 
		res.send ("ERROR:", err);
	  });	  
});	//END router.get('/system_user_manager/user_login',


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
		
		res.send (out_data);

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
		
		res.send (out_data);
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
		
		res.send (out_data);
		
	  })
	  .catch (function (err) {
		console.log("ERROR:", err); 
		res.send ("ERROR:", err);
	  });	  
}); //END router.get('/system_user_manager/user_logout'

 module.exports = router;
