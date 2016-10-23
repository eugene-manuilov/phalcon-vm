$settings = loadjson('/srv/www/default/data/settings.json')

class { 'phalconvm_mysql': settings => $settings[mysql] }
