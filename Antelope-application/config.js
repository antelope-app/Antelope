//var constants = require('./constants');

var config = function(app){
  switch(app.get('env')){
    case 'development':
      process.env.NODE_ENV = "development"
      process.env.MYSQL_HOST = "localhost"
      process.env.MYSQL_USERNAME = "root"
      process.env.MYSQL_PW = "Spudboy1"

    case 'production':
      // USES .ebextensions

    default:
      
  }
}

module.exports = config;