/*agent
	.set('cert file', certFile)
	.set('key file', keyFile)
	.enable('sandbox')

console.log(agent)

agent.connect(function(err) {
	if (err && err.name === 'GatewayAuthorizationError') {
	    console.log('Authentication Error: %s', err.message);
	    process.exit(1);
	}

	// handle any other err (not likely)
	else if (err) {
		throw err;
	}

	// it worked!
	var env = agent.enabled('sandbox')
		? 'sandbox'
		: 'production';

	console.log('apnagent [%s] gateway connected', env);
})

module.exports = agent*/

