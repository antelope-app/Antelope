// dependencies
var express = require('express');
var app = express();
var router = express.Router()

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

var bodyParser = require('body-parser');
app.use(bodyParser.urlencoded({
  extended: true
}));

// Asset paths
app.use(express.static(__dirname + '/public'));

// env config
require('./config')(app); // pass global app to config file and set ENV vars

// DB config
var dbConfig = {
    host: process.env.MYSQL_HOST,
    user: process.env.MYSQL_USERNAME,
    password: process.env.MYSQL_PW,
    database: 'antelope',
    port: '3306'
}
console.log(dbConfig);
var connection = mysql.createConnection(dbConfig)

connection.connect(function(err){
  if(err){
    console.log('Error connecting to Db', err);
    return;
  }
  console.log('Connection established');
});

connection.query('CREATE DATABASE IF NOT EXISTS antelope', function(err) {
  if (err) {
    console.log(err)
    throw err
  }
  connection.query('USE antelope', function(err) {
    if (err) { console.log(err); throw err;}
    connection.query('CREATE TABLE IF NOT EXISTS users(' + 
      'id INT NOT NULL AUTO_INCREMENT,' +
      'PRIMARY KEY(id),' +
      'device_token VARCHAR(200),' +
      'created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,' +
      'updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)', function(err) {

      if (err) throw err;

      connection.end(function(err) {

      })
    })
  })
})

// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'jade');

// css preprocessor
sass.render({
  file: "./public/stylesheets/sass/index.scss",
  outFile: "./public/stylesheets/index.css",
  outputStyle: "compressed"
}, function(err, result) {
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

module.exports.createConnection = function() {
  var connection = mysql.createConnection({
    host: process.env.MYSQL_HOST,
    user: process.env.MYSQL_USERNAME,
    password: process.env.MYSQL_PW,
    database: 'antelope',
    port: '3306'
  })

  connection.connect(function(err){
    if(err){
      console.log('Error connecting to Db', err);
      return;
    }
    console.log('Connection established');
  });

  return connection
}
