var User = require('../models/user')
var apn = require('apn')
var main = require('../app')

var q = require('q')
var moment = require('moment')
var scheduler = require('node-schedule')

module.exports = function(app) {
	app.get('/users', function(req, res, next) {

	})

	app.post('/users', function(req, res, next) {

		console.log('post to users')

		var userPost = q.defer()

		var apnConnection = main.apnConnection();
		var token = req.body.device_apn_token

		User.getByToken(token, function(entry) {
			if (entry) {
				console.log(entry)
				res.send("Already registered")
			} else {
				User.create(req.body, function(err, result) {
					if (err) throw err;
					var userId = result.insertId

					User.get(userId, function(result) {
						if (result) {
							userPost.resolve(result)
						}
					})

					res.send("Created new user")
				})
			}
		})

		userPost.promise.then(function(user) { // to notify
			var m = moment.utc(new Date())
			var offsetTime = m.add(15, 'seconds').format()

			var note = "hello"
			scheduler.scheduleJob(offsetTime, function(connection, user, note) {
				sendPushNotification(connection, user)

				user.trial_period = false
				User.update(user, function(err, result) {
					if (err) throw err;
					else {
						console.log('updated with result', result)
					}
				})
				console.log(note)
			}.bind(null, apnConnection, user, note))
		})
	})

	app.post('/users/send_notification', function(req, res, next) {
		User.get(req.body.id, function(user) {
			if (user) {
				var apnConnection = main.apnConnection();

				sendPushNotification(apnConnection, user)
			} else {
				res.status(404).send("Not found")
			}
		})
	})

	app.get('/users/:id/trial_status', function(req, res, next) {
		console.log(req.params)

		User.get(req.params.id, function(entry) {
			if (entry) {
				res.status(200).send(!!+entry.trial_period)
			} else {
				res.status(404).send("Not found")
			}
		})
	})

	function sendPushNotification(connection, user) {
		var device = new apn.Device(user.device_apn_token)
		var note = new apn.Notification()

		note.badge = 3;
		note.sound = "ping.aiff";
		note.alert = "Trial period is over. Time to share!";
		note.contentAvailable = 1;
		note.payload = { data: { id: user.id } };

		connection.pushNotification(note, device)
	}
}
