(function(angular, phalconvm) {
	phalconvm.app = angular.module('PhalconVM', ['ngMaterial', 'ngRoute']);

	phalconvm.app.config(['$routeProvider', '$locationProvider', function($routeProvider, $locationProvider) {
		$routeProvider.when('/env/:service', {
			controller: 'EnvCtrl',
			controllerAs: 'env',
			template: function(params) {
				var id = 'tmpl-environment-' + params.service,
					template = document.getElementById(id);

				return template ? template.innerHTML : ' ';
			}
		});

		$routeProvider.when('/tools/:tool', {
			controller: 'EnvCtrl',
			controllerAs: 'env',
			template: function(params) {
				var id = 'tmpl-tools-' + params.tool,
					template = document.getElementById(id);

				return template ? template.innerHTML : ' ';
			}
		});

		$routeProvider.otherwise({redirectTo: ''});

		$locationProvider.html5Mode(false);
	}]);

	phalconvm.app.controller('AppCtrl', ['$scope', '$mdSidenav', function ($scope, $mdSidenav) {
		$scope.menu = phalconvm.menu;

		$scope.toggleSidenav = function() {
			$mdSidenav('left').toggle();
		};
	}]);

	phalconvm.app.controller('EnvCtrl', [function() {
	}]);
})(angular, phalconvm);