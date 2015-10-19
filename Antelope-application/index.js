// dependencies
var express = require('express');
var app = express();
var server = require('http').Server(app);
var inspect = require('util').inspect;
var mysql = require('mysql');

var fs = require('fs');
var path = require('path');
var logger = require('morgan');
var cookieParser = require('cookie-parser');
var cookieSession = require('cookie-session');

var sass = require('node-sass');

app.use(logger('dev'));

// Asset paths
app.use(express.static(__dirname + '/public'));

// env config
require('./config')(app); // pass global app to config file and set ENV vars

// DB config
var connection = mysql.createConnection({
    host: "localhost",
    user: process.env["DB_USER_NAME"],
    password: process.env["DB_PW"],
    database: 'adblock',
    port: '3306'
})

connection.connect(function(err){
  if(err){
    console.log('Error connecting to Db', err);

    console.log(process.env)
    return;
  }
  console.log('Connection established');
});

connection.end(function(err) {
  // The connection is terminated gracefully
  // Ensures all previously enqueued queries are still
  // before sending a COM_QUIT packet to the MySQL server.
});

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
var routes = require('./routes')(app, connection);

module.exports.app = app;
