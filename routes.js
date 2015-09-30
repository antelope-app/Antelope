var fs = require('fs');
var zlib = require('zlib');

var routes = function(app, db){
  
  app.get('/', function(req, res, next) {
    console.log(req.url);
    //req.collection = db.collection('posts');
  	res.render('./index.jade', {
      
  		title: "Home"
  	});
  });
}

module.exports = routes;