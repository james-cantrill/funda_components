
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
						title: 'Welcome '
				}
					});
		};
		
	  })
	  .catch (function (err) {
		console.log("ERROR:", err); 
		res.send ("ERROR:", err);
	  });

	  
});	//END router.get('/system_user_manager/user_login',


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
