class { 'phalconvm':
	settings => deep_merge(
		loadjson( '/srv/www/default/data/defaults.json', {} ),
		loadjson( '/srv/www/default/data/settings.json', {} )
	)
}
