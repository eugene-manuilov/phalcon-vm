<?php

class IndexController extends \Phalcon\Mvc\Controller {

	public function indexAction() {
		$phalconvm = array(
			'app'  => null,
			'menu' => array(
				'environment' => array(
					array(
						'label' => 'Web Sevices',
						'items' => array( 'nginx' => 'Nginx' ),
					),
					array(
						'label' => 'Databases',
						'items' => array( 'mysql' => 'MySQL', 'postgres' => 'PostgreSQL', 'mongodb' => 'MongoDB' ),
					),
					array(
						'label' => 'Caching Systems',
						'items' => array( 'redis' => 'Redis', 'memcached' => 'Memcached' ),
					),
					array(
						'label' => 'Queue Systems',
						'items' => array( 'gearman' => 'Gearman', 'rabbitmq' => 'RabbitMQ' ),
					),
					array(
						'label' => 'Search Engines',
						'items' => array( 'elastic' => 'Elasticsearch', 'sphinx' => 'Sphinx' ),
					),
				),
				'tools' => array(
					array(
						'label' => false,
						'items' => array(
//							'webgrind'              => 'Webgrind',
							'/php-info.php'         => 'PHP Info',
							'/php-status?html&full' => 'PHP Status',
//							'opcache-status'        => 'Opcache Status',
						),
					),
				),
			),
		);

		$this->tag->setTitle( 'Phalcon VM' );

		$this->assets->addCss( '//fonts.googleapis.com/css?family=Roboto:300,400,500,700,400italic', false );
		$this->assets->addCss( 'css/app.css' );

		$this->assets->addInlineJs( sprintf( 'var phalconvm = %s;', json_encode( $phalconvm ) ) );
		$this->assets->addJs( 'js/app.js' );

		$this->view->phalconvm = $phalconvm;
	}

}