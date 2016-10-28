<?php

use Phalcon\Config\Adapter\Yaml;

class IndexController extends \Phalcon\Mvc\Controller {

	public function indexAction() {
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
		$phalconvm['data'] = array_merge( $defaults, $settings );
		if ( ! empty( $phalconvm['data']['phpMyAdmin']['enabled'] ) ) {
			$phalconvm['menu']['tools'][0]['items']['/phpmyadmin'] = 'phpMyAdmin';
		}

		$fields = new Yaml( APP_PATH . '/config/groups.yml' );
		$fields = $fields->toArray();

		$this->tag->setTitle( 'Phalcon VM' );

		$this->assets->addCss( '//fonts.googleapis.com/css?family=Roboto:300,400,500,700,400italic', false );
		$this->assets->addCss( 'css/app.css' );

		$this->assets->addInlineJs( sprintf( 'var phalconvm = %s;', json_encode( $phalconvm ) ) );
		$this->assets->addJs( 'js/app.js' );

		$this->view->phalconvm = $phalconvm;
		$this->view->groups = $fields;
	}

	public function saveAction() {
		if ( ! $this->request->isPost() ) {
			$this->response->redirect( '/', false );
			return false;
		}

		$postdata = trim( file_get_contents( "php://input" ) );
		file_put_contents( BASE_PATH . '/data/settings.json', $postdata );

		return false;
	}

}
