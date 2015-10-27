var app = require('../app');

module.exports.get = function(id, callback) {
	var connection = app.createConnection()

	connection.query("SELECT * FROM users WHERE id = ?", +id, function(err, result) {
		connection.end()
		if (err || result.length === 0) {
			callback()
		} else {
			callback(result[0])
		}
	})
}

module.exports.getByToken = function(device_apn_token, callback) {
	var connection = app.createConnection()

	console.log('looking for user with token ', device_apn_token)

	connection.query("SELECT DISTINCT id, device_apn_token FROM users WHERE device_apn_token = ?", device_apn_token, function(err, result) {
		connection.end()
		if (err || !result || result.length === 0) {
			callback()
		} else {
			console.log('result is ', result[0])
			callback(result[0])
		}
	})
}

module.exports.create = function(user, callback) {
	var connection = app.createConnection()

	connection.query('INSERT INTO users SET ?', user, function(err, result) {
		connection.end()
		if (err) {
			callback(err)
			return
		} else {
			callback(null, result)
		}
	})
}

module.exports.update = function(user, callback) {
	var connection = app.createConnection()
	var payload = [user, user.id]

	connection.query("UPDATE users SET ? WHERE id = ?", payload, function(err, result) {
		connection.end()
		if (err) {
			callback(err)
		} else {
			callback(null, result)
		}
	})
}

module.exports.query = function() {

}

module.exports.destroy = function() {

}