// system_user_demo_app_vue


var express = require('express')
var expressVue = require('express-vue')
var app = express();

app.engine('vue', expressVue);
app.set('view engine', 'vue');
app.set('views', __dirname + '/views');
app.set('vue', {
    componentsDir: __dirname + '/views/components',
    defaultLayout: 'layout'
});

var routes = require('./routes');


app.use('/', routes);
app.use (express.static ('public'));

app.listen(3000);
console.log('Express server listening on port 3000');
