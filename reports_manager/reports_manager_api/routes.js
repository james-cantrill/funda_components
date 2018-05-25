
var express = require('express');
var router = express.Router();
var user_name;
var user_login;

var seneca = require('seneca')();
var Promise = require('bluebird');

const Cors = require("cors");

router.use(Cors());

var act = Promise.promisify(seneca.act,  {context: seneca});
seneca.use( require('./report_manager.js') );

router.get('/report_manager', function(req, res){  
  console.log ('in routes /report_manager');
  res.json({'response': 'made contact with report_manager/'});
});

router.get('/report_manager/load_report_list', function (req, res) {
	user_login = req.query.login;
	//console.log (req.query);
	act ({  role:'report_manager', 
	        cmd:'load_report_list', 
			_in_data: {
					'login': req.query.login
			}
		})
	  .then (function (result) {
		var returned_json = JSON.parse (JSON.stringify (result));
		var out_data = returned_json[0].action_load_report_list_vue_jstree;
		
		res.send (out_data);
		
	  })
	  .catch (function (err) {
		console.log("ERROR:", err); 
		res.send ("ERROR:", err);
	  });	  
});	//END router.get('/report_manager/load_report_list',



router.get('/report_manager/load_selected_report', function (req, res) {
	
	act ({  role:'report_manager', 
	        cmd:'load_selected_report', 
			_in_data: {
					login: req.query.login,
					report_id:  req.query.report_id
			}
		})
	  .then(function (result) {
		var returned_json = JSON.parse (JSON.stringify (result));
		var out_data = returned_json[0].action_load_selected_report;
		res.send (out_data);
	  })
	  .catch(function (err) {
		console.log("ERROR:", err); 
		res.send ("ERROR:", err);
	  });
});	//END router.get('/report_manager/load_selected_report',

 module.exports = router;
