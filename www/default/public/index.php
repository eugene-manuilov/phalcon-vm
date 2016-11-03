<?php

use Phalcon\Di\FactoryDefault;

error_reporting( E_ALL );

define( 'BASE_PATH', dirname( __DIR__ ) );
define( 'APP_PATH', BASE_PATH . '/app' );

try {
	$di = new FactoryDefault();
	include APP_PATH . "/config/services.php";

	$config = $di->getConfig();

	$loader = new \Phalcon\Loader();
	$loader->registerDirs( array( $config->application->controllersDir ) );
	$loader->register();

	$application = new \Phalcon\Mvc\Application( $di );

	$response = $application->handle();
	$response->send();
} catch ( \Exception $e ) {
	echo $e->getMessage() . '<br>';
	echo '<pre>' . $e->getTraceAsString() . '</pre>';
}