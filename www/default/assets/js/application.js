(function(angular, phalconvm, document) {
	phalconvm.app = angular.module('PhalconVM', ['ngMaterial', 'ngRoute', 'ngSanitize', 'ngMessages']);
	phalconvm.app.config(['$routeProvider', '$locationProvider', function($routeProvider, $locationProvider) {
		$routeProvider.when('/', {
			controller: 'HomeCtrl',
			controllerAs: 'home',
			template: function() {
				return document.getElementById('tmpl-homepage').innerHTML;
			}
		});

		$routeProvider.when('/site/:site', {
			controller: 'SiteCtrl',
			controllerAs: 'site',
			template: function() {
				return document.getElementById('tmpl-edit-site').innerHTML;
			}
		});

		$routeProvider.when('/env/:service', {
			controller: 'EnvCtrl',
			controllerAs: 'env',
			template: function(params) {
				var template = document.getElementById('tmpl-' + params.service);

				if (template) {
					return template.innerHTML;
				}

				return ' ';
			}
		});

		$routeProvider.when('/iframe:href*', {
			controller: 'FrameCtrl',
			controllerAs: 'frm',
			template: function(params) {
				return '<iframe src="' + params.href + '" width="100%" height="100%" md-content style="border:none"/>';
			}
		});

		$locationProvider.html5Mode(true);
	}]);
})(angular, phalconvm, document);
