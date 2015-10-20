var User = require('../models/user')

module.exports = function(app) {
	app.get('/users', function(req, res, next) {

	})

	app.post('/users', function(req, res, next) {
		console.log("registered token", req.body)
		User.create(req.body)
	})
}
