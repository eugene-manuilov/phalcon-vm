<?php

class IndexController extends \Phalcon\Mvc\Controller {

	public function indexAction() {
		$data = file_get_contents( BASE_PATH . '/data/settings.json' );

		$phalconvm = new \Phalcon\Config\Adapter\Yaml( APP_PATH . '/config/phalconvm.yml' );
		$phalconvm = $phalconvm->toArray();
		$phalconvm['data'] = json_decode( $data, true );

		$this->tag->setTitle( 'Phalcon VM' );

		$this->assets->addCss( '//fonts.googleapis.com/css?family=Roboto:300,400,500,700,400italic', false );
		$this->assets->addCss( 'css/app.css' );

		$this->assets->addInlineJs( sprintf( 'var phalconvm = %s;', json_encode( $phalconvm ) ) );
		$this->assets->addJs( 'js/app.js' );

		$this->view->phalconvm = $phalconvm;
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