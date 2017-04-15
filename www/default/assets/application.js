import angular from 'angular';
import ngMaterial from 'angular-material';
import ngRoute from 'angular-route';
import ngSanitize from 'angular-sanitize';
import ngMessages from 'angular-messages';

import styles from './css/app.scss';

import config from './js/config';
import AppController from './js/app';
import EnvController from './js/env';
import FrameController from './js/frame';
import HomeController from './js/home';
import SiteController from './js/site';

angular
	.module('PhalconVM', [ngMaterial, ngRoute, ngSanitize, ngMessages])
	.config(config)
	.controller('AppCtrl', AppController)
	.controller('EnvCtrl', EnvController)
	.controller('FrameCtrl', FrameController)
	.controller('HomeCtrl', HomeController)
	.controller('SiteCtrl', SiteController);