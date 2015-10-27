var create_users_table = new Migration({
	up: function() {
		this.create_table('users', function(t) {
			t.column('id', 'integer', { auto_increment: true });
			t.primary_key('id');
			t.string('device_apn_token');
			t.string('device_id');
			t.column('trial_period', 'boolean', { default_value: true });
			t.timestamp('created_at');

			t.index('device_id');
			t.index('device_apn_token');
		})
	},
	down: function() {
		this.drop_table('users')
	}
});