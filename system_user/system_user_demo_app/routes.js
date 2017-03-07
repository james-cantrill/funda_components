
var express = require('express');
var router = express.Router();

var seneca = require('seneca')();
var web = require('seneca-web');
var Promise = require('bluebird');

var act = Promise.promisify(seneca.act,  {context: seneca});
seneca.use( require('../system_user_manager/system_user_manager.js') );

router.get('/', function(req, res){  
  res.render('index', {
        title: 'Please Log In'
  });
});

router.get('/system_user_manager/user_login', function (req, res) {
	console.log(req.query);
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

 module.exports = router;
