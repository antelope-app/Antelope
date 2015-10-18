//var constants = require('./constants');

var config = function(app){
  switch(app.get('env')){
    case 'development':
      return {
        'mongodb': 'mongodb://localhost:27017/node-blog',
        //'awsAccessKeyId': constants.AWS_ACCESS_KEY_ID,
        //'awsSecretAccessKey': constants.AWS_SECRET_ACCESS_KEY,
        //'s3BucketName': constants.S3_BUCKET_NAME
      };

    case 'production':
      return {
        'mongodb': process.env.MONGOLAB_URI,
      };

    default:
      return {
        
      };
  }
}

module.exports = config;