<?php

class IndexController extends \Phalcon\Mvc\Controller {

	public function initialize() {
		$this->tag->setTitle( 'Phalcon VM' );

		$this->assets->addCss( '//fonts.googleapis.com/css?family=Roboto:300,400,500,700,400italic', false );
		$this->assets->addCss( 'css/app.css' );

		$this->assets->addJs( 'js/app.js' );
	}

	public function indexAction() {

	}

}