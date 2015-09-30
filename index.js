// dependencies
var express = require('express');
var app = express();
var server = require('http').Server(app);
var inspect = require('util').inspect;

var fs = require('fs');
var path = require('path');
var logger = require('morgan');
var cookieParser = require('cookie-parser');
var cookieSession = require('cookie-session');

var sass = require('node-sass');
var sassMiddleware = require('node-sass-middleware')

app.use(logger('dev'));

// Asset paths
app.use(express.static(__dirname + '/public'));
app.use(sassMiddleware({
    src: __dirname,
    dest: __dirname
}))

// env config
app.config = require('./config')(app); // pass global app to config file and get ENV vars

// DB config
var mongoskin = require('mongoskin');
var db = mongoskin.db(app.config.mongodb); // get URI from config file

// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'jade');

// css preprocessor
sass.render({
  file: "./public/stylesheets/sass/index.scss",
  outFile: "./public/stylesheets/index.css",
  outputStyle: "compressed"
}, function(err, result) {
    console.log(err)
    if(!err) {
        // No errors during the compilation, write this result on the disk 
        fs.writeFile("./public/stylesheets/index.css", result.css, function(err) {
            if(!err) {
                console.log('compiled')
            }
        });
    }
});

// development error handler
// will print stacktrace
if (app.get('env') === 'development') {
    app.use(function(err, req, res, next) {
        res.status(err.status || 500);
        res.render('error', {
            message: err.message,
            error: err
        });
    });
}

// production error handler
// no stacktraces leaked to user
app.use(function(err, req, res, next) {
    res.status(err.status || 500);
    res.render('error', {
        message: err.message,
        error: {}
    });
});

// IMPLEMENTATION
app.listen(process.env.PORT || 4000);

// routing
var routes = require('./routes')(app, db);

module.exports.app = app;
module.exports.db = db;
