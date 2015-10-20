var app = require('../app')

module.exports.get = function() {
	db.query("SELECT FROM users")
}

module.exports.create = function(user) {
	console.log('creating')
	var connection = app.createConnection()

	connection.query('INSERT INTO users SET ?', user, function(err, result) {
		if (err) {
			console.error(err)
			return
		}

		console.log(result)

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