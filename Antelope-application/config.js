//var constants = require('./constants');

var config = function(app){
  switch(app.get('env')){
    case 'development':
      process.env.DB_USER_NAME = "root"
      

    case 'production':
      // USES .ebextensions

    default:
      
  }
}

module.exports = config;