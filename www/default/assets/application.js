import angular from 'angular';
import ngMaterial from 'angular-material';
import ngRoute from 'angular-route';
import ngSanitize from 'angular-sanitize';
import ngMessages from 'angular-messages';

import styles from './css/app.scss';

import config from './js/config';
import getAppController from './js/app';
import getEnvController from './js/env';
import getFrameController from './js/frame';
import getHomeController from './js/home';
import getSiteController from './js/site';

const app = angular.module('PhalconVM', [ngMaterial, ngRoute, ngSanitize, ngMessages]);

// config
app.config(config);

// controllers
app.controller('AppCtrl', getAppController());
app.controller('EnvCtrl', getEnvController());
app.controller('FrameCtrl', getFrameController());
app.controller('HomeCtrl', getHomeController());
app.controller('SiteCtrl', getSiteController());