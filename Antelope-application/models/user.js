var app = require('../app');
var q = require('q');

module.exports.get = function() {
}

module.exports.getByToken = function(device_token, callback) {
	var connection = app.createConnection()

	console.log('getting by token')
	connection.query("SELECT DISTINCT device_token FROM users WHERE device_token = ?", device_token, function(err, result) {

		if (err || result.length === 0) {
			callback()
		} else {
			callback(result)
		}
		connection.end()
	})
}

module.exports.create = function(user) {
	var connection = app.createConnection()

	connection.query('INSERT INTO users SET ?', user, function(err, result) {
		if (err) {
			console.error(err)
			return
		}

		connection.end()

	})
}

module.exports.query = function() {

}

module.exports.update = function() {

}

module.exports.destroy = function() {

}

function setTimestampForResource(resource) {
	var timestamp = getCurrentTimestamp()

}

function getCurrentTimestamp() {
	var d = new Date,
    dformat = [d.getFullYear(),
               d.getMonth() + 1,
               d.getFullYear()].join('-') + ' ' +
              [d.getHours(),
               d.getMinutes(),
               d.getSeconds()].join(':');

    return dformat;
}