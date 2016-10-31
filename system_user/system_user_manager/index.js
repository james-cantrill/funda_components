var express = require('express');
var router = express.Router();

var seneca = require('seneca')();
var web = require('seneca-web');
var Promise = require('bluebird');

var act = Promise.promisify(seneca.act,  {context: seneca});
seneca.use( require('./system_user_manager.js') );

/* GET home page. */
router.get('/', function(req, res, next) {
  res.render('index', { title: 'System User Manager' });
});

router.get('/system_user_manager/test', function (req, res) {
	act ({role:'system_user_manager', cmd:'test'})
	  .then(function (result) {
		res.render('test', { title: 'System User Manager - Test', data: JSON.stringify (result) });
	  })
	  .catch(function (err) {
		console.log("ERROR:", err); 
	  });
 });
 
 router.get('/system_user_manager/get_one_row', function (req, res) {
	act ({role:'system_user_manager', cmd:'get_one_row'})
	  .then(function (result) {
		res.send (JSON.stringify (result));
		//res.render('test', { title: 'System User Manager - get_one_row', data: JSON.stringify (result) });
	  })
	  .catch(function (err) {
		console.log("ERROR:", err); 
	  });
 });

router.get('/system_user_manager/add_one_user', function (req, res) {
	//console.log(req.query);
	//var _in_data = req.query;
	//console.log(_in_data);
	act ({  role:'system_user_manager', 
	        cmd:'add_one_user', 
			_in_data: {
					firstname: req.query.firstname,
					lastname: req.query.lastname,
					login: req.query.login,
					password:  req.query.password,
					changing_user_login: req.query.changing_user_login
			}
		})
	  .then(function (result) {
		res.send (JSON.stringify (result));
	  })
	  .catch(function (err) {
		console.log("ERROR:", err); 
		res.send ("ERROR:", err);
	  });
});
	  
router.get('/system_user_manager/user_login', function (req, res) {
	act ({  role:'system_user_manager', 
	        cmd:'user_login', 
			_in_data: {
					login: req.query.login,
					password:  req.query.password
			}
		})
	  .then (function (result) {
		res.send (JSON.stringify (result));
	  })
	  .catch (function (err) {
		console.log("ERROR:", err); 
		res.send ("ERROR:", err);
	  });	  
});

router.get('/system_user_manager/user_logout', function (req, res) {
	act ({  role:'system_user_manager', 
	        cmd:'user_logout', 
			_in_data: {
					login: req.query.login
			}
		})
	  .then (function (result) {
		res.send (JSON.stringify (result));
	  })
	  .catch (function (err) {
		console.log("ERROR:", err); 
		res.send ("ERROR:", err);
	  });	  
});

//change_password
router.get('/system_user_manager/change_password', function (req, res) {
	act ({  role:'system_user_manager', 
	        cmd:'change_password', 
			_in_data: {
					login: req.query.login,
					new_password:  req.query.password,
					changing_user_login: req.query.changing_user_login
			}
		})
	  .then (function (result) {
		res.send (JSON.stringify (result));
	  })
	  .catch (function (err) {
		console.log("ERROR:", err); 
		res.send ("ERROR:", err);
	  });	  
});

//change_user_allowed_actions
router.get('/system_user_manager/change_user_allowed_actions', function (req, res) {
	act ({  role:'system_user_manager', 
	        cmd:'change_user_allowed_actions', 
			_in_data: {
					login: req.query.login,
					service:  req.query.service,
					action: req.query.action,
					task: req.query.task,
					changing_user_login: req.query.changing_user_login
			}
		})
	  .then (function (result) {
		res.send (JSON.stringify (result));
	  })
	  .catch (function (err) {
		console.log("ERROR:", err); 
		res.send ("ERROR:", err);
	  });	  
});


			
 module.exports = router;

 