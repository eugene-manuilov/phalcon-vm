<?php

$dirs = array(
	$config->application->controllersDir,
	$config->application->modelsDir
);

$loader = new \Phalcon\Loader();
$loader->registerDirs( $dirs );
$loader->register();
