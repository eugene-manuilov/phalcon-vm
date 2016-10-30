$defaultSettings = loadjson( '/srv/www/default/data/defaults.json', {} )
$userSettings = loadjson( '/srv/www/default/data/settings.json', {} )

class { 'phalconvm': settings => deep_merge( $defaultSettings, $userSettings ) }
