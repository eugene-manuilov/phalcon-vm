<?php

use Phalcon\Config\Adapter\Yaml;
use Phalcon\Dispatcher;
use Phalcon\Events\Event;
use Phalcon\Events\Manager as EventsManager;
use Phalcon\Mvc\Router;
use Phalcon\Mvc\Dispatcher as MvcDispatcher;
use Phalcon\Mvc\Dispatcher\Exception as DispatchException;

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

	$router->add( '/save/env', array(
		'controller' => 'index',
		'action'     => 'saveEnv',
	) );

	$router->add( '/save/site', array(
		'controller' => 'index',
		'action'     => 'saveSite',
	) );

	return $router;
} );

$di->setShared( 'dispatcher', function () {
	$eventsManager = new EventsManager();
	$eventsManager->attach( 'dispatch:beforeException', function( Event $event, $dispatcher, Exception $exception ) {
		$index = array( "controller" => "index", "action" => "index" );

		if ( $exception instanceof DispatchException ) {
			$dispatcher->forward( $index );
			return false;
		}

		switch ( $exception->getCode() ) {
			case Dispatcher::EXCEPTION_HANDLER_NOT_FOUND:
			case Dispatcher::EXCEPTION_ACTION_NOT_FOUND:
				$dispatcher->forward( $index );
				return false;
		}
	} );

	$dispatcher = new MvcDispatcher();
	$dispatcher->setEventsManager($eventsManager);

	return $dispatcher;
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

	$tools = array(
		'phpmyadmin'        => 'phpMyAdmin',
		'phppgadmin'        => 'phpPgAdmin',
		'phpmemcachedadmin' => 'phpMemcacheAdmin',
	);

	foreach ( $tools as $key => $label ) {
		$filename = sprintf( '%s/public/%s/index.php', BASE_PATH, $key );
		if ( ! empty( $phalconvm['data'][ $label ]['enabled'] ) && file_exists( $filename ) ) {
			$iframe = '/iframe/' . $key;
			$phalconvm['menu']['tools'][ $iframe ] = array( 'label' => $label );
		}
	}

	if ( empty( $phalconvm['menu']['tools'] ) ) {
		unset( $phalconvm['menu']['tools'] );
	}

	return $phalconvm;
} );

$di->setShared( 'fieldsConfig', function() {
	$fields = new Yaml( APP_PATH . '/config/fields.yml' );
	$fields = $fields->toArray();

	return $fields;
} );
