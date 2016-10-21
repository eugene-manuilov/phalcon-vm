<?php

use Phalcon\Mvc\View;
use Phalcon\Mvc\View\Engine\Php as PhpEngine;
use Phalcon\Mvc\Url as UrlResolver;
use Phalcon\Mvc\Router;

$di->setShared( 'config', function () {
	return include APP_PATH . "/config/config.php";
} );

$di->setShared( 'url', function () {
	$config = $this->getConfig();

	$url = new UrlResolver();
	$url->setBaseUri( $config->application->baseUri );

	return $url;
} );

$di->setShared( 'view', function () {
	$config = $this->getConfig();

	$view = new View();
	$view->setDI( $this );
	$view->setViewsDir( $config->application->viewsDir );

	$view->registerEngines( [
		'.phtml' => PhpEngine::class
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