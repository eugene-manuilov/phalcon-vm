<?php

class IndexController extends \Phalcon\Mvc\Controller {

	public function indexAction() {
		$phalconvm = new \Phalcon\Config\Adapter\Yaml( APP_PATH . '/config/phalconvm.yml' );
		$phalconvm = $phalconvm->toArray();

		$this->tag->setTitle( 'Phalcon VM' );

		$this->assets->addCss( '//fonts.googleapis.com/css?family=Roboto:300,400,500,700,400italic', false );
		$this->assets->addCss( 'css/app.css' );

		$this->assets->addInlineJs( sprintf( 'var phalconvm = %s;', json_encode( $phalconvm ) ) );
		$this->assets->addJs( 'js/app.js' );

		$this->view->phalconvm = $phalconvm;
	}

}