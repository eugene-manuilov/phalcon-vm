<?php

use Phalcon\Mvc\Controller;

class ControllerBase extends Controller {

	public function initialize() {
		$this->tag->setTitle( "Phalcon VM" );

		$this->assets->addCss( "css/app.css" );
		$this->assets->addJs( "js/app.js" );
	}

}
