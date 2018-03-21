// system_user_api


var express = require('express')
var app = express();

var routes = require('./routes');



app.use('/', routes);
app.use (express.static ('public'));



app.listen(3000);
console.log('system_user_api Express server listening on port 3000');
