var User = require('../models/user')

module.exports = function(app) {
	app.get('/users', function(req, res, next) {

	})

	app.post('/users', function(req, res, next) {

		User.getByToken(req.body.device_token, function(token) {
			if (token) {
				console.log('already registered', token) 
			} else {
				console.log('creating', req.body.device_token)
				User.create(req.body)
			}
		})
	})
}
