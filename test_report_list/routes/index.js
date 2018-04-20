var express = require('express');
var axios = require('axios');
var router = express.Router();

/* GET home page. */
router.get('/', function(req, res, next) {
  res.render('index', { title: 'Please Log In' });
});

/* Try login. */
router.get('/user_login', function(req, res, next) {
  axios.get('http://localhost:3000/system_user_manager/user_login', {
    params: {
      login: req.query.login,
      password:  req.query.password
    }
  })
  .then(function (response) {
    console.log(response.data);
	if (response.data.result_indicator == 'Failure'){
      console.log('in failure ' + response.data.result_indicator);
	   res.render('index', { title: response.data.message });
    } else {
       console.log('In else')
	   res.render('home', { title: 'Welcome ' + response.data.firstname + ' ' + response.data.lastname});
    }
  })
  .catch(function (error) {
    console.log(error);
  });
  
//  res.render('home', { title: 'Welcome' });
});

module.exports = router;
