$defaultSettings = loadjson( '/srv/www/default/data/defaults.json', {} )
$userSettings = loadjson( '/srv/www/default/data/settings.json', {} )
$settings = deep_merge( $defaultSettings, $userSettings )

# class { 'phalconvm_nginx': * => $settings[nginx] }
class { 'phalconvm_mysql': * => $settings[mysql] }
class { 'phalconvm_phpmyadmin': * => $settings[phpMyAdmin] }
# class { 'phalconvm_postgres': * => $settings[postgres] }
# class { 'phalconvm_phppgadmin': * => $settings[phpPgAdmin] }
# class { 'phalconvm_mongodb': * => $settings[mongodb] }
class { 'phalconvm_memcached': * => $settings[memcached] }
class { 'phalconvm_phpmemcacheadmin': * => $settings[phpMemcacheAdmin] }
# class { 'phalconvm_gearman': * => $settings[gearman] }
# class { 'phalconvm_rabbitmq': * => $settings[rabbitmq] }
# class { 'phalconvm_elasticsearch': * => $settings[elasticsearch] }
class { 'phalconvm_sphinx': * => $settings[sphinx] }
