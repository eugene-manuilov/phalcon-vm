(function(angular, phalconvm) {
	phalconvm.app = angular.module('PhalconVM', ['ngMaterial', 'ngRoute', 'ngSanitize']);

	phalconvm.app.config(['$routeProvider', '$locationProvider', function($routeProvider, $locationProvider) {
		$routeProvider.when('/env/:service', {
			controller: 'EnvCtrl',
			controllerAs: 'env',
			template: function(params) {
				var template = document.getElementById('tmpl-' + params.service);

				if (template) {
					return '<md-content layout-padding>' + template.innerHTML + '</md-content>';
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

	phalconvm.app.controller('AppCtrl', ['$mdSidenav', '$mdDialog', '$http', function ($mdSidenav, $mdDialog, $http) {
		var self = this;

		self.nasty = false;
		self.menu = phalconvm.menu;

		self.setNasty = function() {
			self.nasty = true;
		};

		self.saveChanges = function() {
			self.nasty = false;

			$http.post('/save', phalconvm.data);

			$mdDialog.show(
				$mdDialog.alert()
					.clickOutsideToClose(true)
					.title('Saved changes')
					.htmlContent('Changes have been saved. Please, do not forget to halt your vagrant box<br>and up it again with <b>--provision</b> mode.')
					.ok('Got it!')
			);
		};

		self.toggleSidenav = function() {
			$mdSidenav('left').toggle();
		};
	}]);

	phalconvm.app.controller('EnvCtrl', ['$scope', '$rootScope', '$routeParams', function($scope, $rootScope, $routeParams) {
		$rootScope.title = phalconvm.menu.environment['/env/' + $routeParams.service].label;
		$rootScope.saveButton = true;
		$scope.data = phalconvm.data;
	}]);

	phalconvm.app.controller('FrameCtrl', ['$scope', '$rootScope', '$routeParams', function($scope, $rootScope, $routeParams) {
		$rootScope.title = phalconvm.menu.environment['/iframe/' + $routeParams.href].label;
		$rootScope.saveButton = false;
	}]);
})(angular, phalconvm);
