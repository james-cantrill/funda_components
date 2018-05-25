
var express = require('express');
var router = express.Router();
var user_name;
var user_login;

var seneca = require('seneca')();
var Promise = require('bluebird');

const Cors = require("cors");

router.use(Cors());

var act = Promise.promisify(seneca.act,  {context: seneca});
seneca.use( require('./programs_manager.js') );

router.get('/programs_manager', function(req, res){  
  //console.log ('in routes /programs_manager');
  res.json({'response': 'made contact with programs_manager/'});
});

router.get('/programs_manager/load_program_list', function (req, res) {
	user_login = req.query.login;
	//console.log (req.query);
	act ({  role:'programs_manager', 
	        cmd:'list_user_visible_programs', 
			_in_data: {
					'login': req.query.login
			}
		})
	  .then (function (result) {
		var returned_json = JSON.parse (JSON.stringify (result));
		var out_data = returned_json[0].action_load_program_list_vue_jstree;
		
		res.send (out_data);
		
	  })
	  .catch (function (err) {
		console.log("ERROR:", err); 
		res.send ("ERROR:", err);
	  });	  
});	//END router.get('/programs_manager/load_program_list',



 module.exports = router;
