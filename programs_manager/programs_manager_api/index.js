var express = require('express');
var router = express.Router();

var seneca = require('seneca')();
var web = require('seneca-web');
var Promise = require('bluebird');

var act = Promise.promisify(seneca.act,  {context: seneca});
seneca.use( require('./programs_manager_api.js') );

/* GET home page. */
router.get('/', function(req, res, next) {
  res.render('index', { title: 'Programs Manager' });
});

router.get('/programs_manager/test', function (req, res) {
	act ({role:'programs_manager_api', cmd:'test'})
	  .then(function (result) {
		res.render('test', { title: 'Programs - Test', data: JSON.stringify (result) });
	  })
	  .catch(function (err) {
		console.log("ERROR:", err); 
	  });
 });
 
 router.get('/programs_manager/get_one_row', function (req, res) {
	console.log ("In /programs_manager/get_one_row");
	act ({role:'programs_manager_api', cmd:'get_one_row'})
	  .then(function (result) {
		res.send (JSON.stringify (result));
		//res.render('test', { title: 'System User Manager - get_one_row', data: JSON.stringify (result) });
	  })
	  .catch(function (err) {
		console.log("ERROR:", err); 
	  });
 });
 
router.get('/programs_manager/list_user_visible_programs', function (req, res) {
	act ({	role:'programs_manager_api', 
			cmd:'list_user_visible_programs',
			_in_data:	{
						login: req.query.login
			}
		})
	  .then(function (result) {
		res.send (JSON.stringify (result));
	  })
	  .catch(function (err) {
		console.log("ERROR:", err); 
	  });
 });

router.get('/programs_manager/list_user_visible_organizations', function (req, res) {
	act ({	role:'programs_manager_api', 
			cmd:'list_user_visible_organizations',
			_in_data:	{
						login: req.query.login
			}
		})
	  .then(function (result) {
		res.send (JSON.stringify (result));
	  })
	  .catch(function (err) {
		console.log("ERROR:", err); 
	  });
 });

router.get ('/programs_manager/change_program_user_visibility', function (req, res) {
	console.log ("In /programs_manager/change_program_user_visibility");
	act ({	role:'programs_manager_api', 
			cmd:'change_program_user_visibility',
			_in_data:	{
						login: req.query.login,
						service: req.query.service,
						program: req.query.program,
						task: req.query.task,
						changing_user_login: req.query.changing_user_login
			}
		})
	  .then(function (result) {
		res.send (JSON.stringify (result));
	  })
	  .catch(function (err) {
		console.log("ERROR:", err); 
	  });
 });

router.get('/programs_manager/change_organization_user_visibility', function (req, res) {
	act ({	role:'programs_manager_api', 
			cmd:'change_organization_user_visibility',
			_in_data:	{
						login: req.query.login,
						service: req.query.service,
						organization_name: req.query.organization_name,
						task: req.query.task,
						changing_user_login: req.query.changing_user_login
			}
		})
	  .then(function (result) {
		res.send (JSON.stringify (result));
	  })
	  .catch(function (err) {
		console.log("ERROR:", err); 
	  });
 });
 



			
 module.exports = router;

 