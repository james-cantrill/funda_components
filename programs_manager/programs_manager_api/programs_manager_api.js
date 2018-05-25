// reports_manager_api


var express = require('express')
var app = express();

var routes = require('./routes');



app.use('/', routes);
app.use (express.static ('public'));



app.listen(5000);
console.log('programs_manager_api Express server listening on port 5000');
