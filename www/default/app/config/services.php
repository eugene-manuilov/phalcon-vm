<?php

use Phalcon\Config\Adapter\Yaml;
use Phalcon\Mvc\Router;

$di->setShared( 'config', function () {
	return new \Phalcon\Config( array(
		'application' => array(
			'appDir'         => APP_PATH . '/',
			'controllersDir' => APP_PATH . '/controllers/',
			'viewsDir'       => APP_PATH . '/views/',
			'baseUri'        => '/',
		),
	) );
} );

$di->setShared( 'url', function () {
	$config = $this->getConfig();

	$url = new \Phalcon\Mvc\Url();
	$url->setBaseUri( $config->application->baseUri );

	return $url;
} );

$di->setShared( 'view', function () {
	$config = $this->getConfig();

	$view = new \Phalcon\Mvc\View();
	$view->setDI( $this );
	$view->setViewsDir( $config->application->viewsDir );

	$view->registerEngines( [
		'.phtml' => \Phalcon\Mvc\View\Engine\Php::class
	] );

	return $view;
} );

$di->setShared( 'router', function() {
	$router = new Router();
	$router->setUriSource( Router::URI_SOURCE_SERVER_REQUEST_URI );

	$router->add( '/', array(
		'controller' => 'index',
		'action'     => 'index',
	) );

	$router->add( '/save', array(
		'controller' => 'index',
		'action'     => 'save',
	) );

	return $router;
} );

$di->setShared( 'phalconvmConfig', function() {
	$defaults = file_get_contents( BASE_PATH . '/data/defaults.json' );
	$defaults = json_decode( $defaults, true );

	$settings = array();
	if ( is_readable( BASE_PATH . '/data/settings.json' ) ) {
		$settings = file_get_contents( BASE_PATH . '/data/settings.json' );
		$settings = json_decode( $settings, true );
		if ( ! $settings ) {
			$settings = array();
		}
	}

	$phalconvm = new Yaml( APP_PATH . '/config/phalconvm.yml' );
	$phalconvm = $phalconvm->toArray();
	$phalconvm['data'] = array_replace_recursive( $defaults, $settings );

	if ( ! empty( $phalconvm['data']['phpMyAdmin']['enabled'] ) && file_exists( BASE_PATH . '/public/phpmyadmin/index.php' ) ) {
		$phalconvm['menu']['tools'][0]['items']['/phpmyadmin'] = 'phpMyAdmin';
	}

	if ( ! empty( $phalconvm['data']['phpPgAdmin']['enabled'] ) && file_exists( BASE_PATH . '/public/phppgadmin/index.php' ) ) {
		$phalconvm['menu']['tools'][0]['items']['/phppgadmin'] = 'phpPgAdmin';
	}

	if ( ! empty( $phalconvm['data']['phpMemcacheAdmin']['enabled'] ) && file_exists( BASE_PATH . '/public/phpmemcachedadmin/index.php' ) ) {
		$phalconvm['menu']['tools'][0]['items']['/phpmemcachedadmin'] = 'phpMemcacheAdmin';
	}

	return $phalconvm;
} );

$di->setShared( 'fieldsConfig', function() {
	$fields = new Yaml( APP_PATH . '/config/groups.yml' );
	$fields = $fields->toArray();

	return $fields;
} );
