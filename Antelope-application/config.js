//var constants = require('./constants');

var config = function(app){
  switch(app.get('env')){
    case 'development':
      process.env.NODE_ENV = "development"
      process.env.MYSQL_HOST = "localhost"
      process.env.MYSQL_USERNAME = "antelope-dev"
      process.env.MYSQL_PW = "antelope"
      break;

    case 'production':
      // USES .ebextensions
      break;

    default:
      
  }
}

module.exports = config;