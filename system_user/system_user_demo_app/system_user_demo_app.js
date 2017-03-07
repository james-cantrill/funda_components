// system_user_demo_app


var express = require('express')
var app = express();

var routes = require('./routes');

app.set('view engine', 'pug');
app.set('views', __dirname + '/views');


app.use('/', routes);
app.use (express.static ('public'));

app.listen(3000);
console.log('Express server listening on port 4000');
