(function(angular, phalconvm) {
	phalconvm.app = angular.module('PhalconVM', ['ngMaterial', 'ngRoute', 'ngSanitize']);

	phalconvm.app.config(['$routeProvider', '$locationProvider', function($routeProvider, $locationProvider) {
		$routeProvider.when('/env/:service', {
			controller: 'EnvCtrl',
			controllerAs: 'env',
			template: function(params) {
				var id = 'tmpl-' + params.service,
					template = document.getElementById(id);

				return template ? template.innerHTML : ' ';
			}
		});

		$routeProvider.otherwise({redirectTo: ''});

		$locationProvider.html5Mode(false);
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

	phalconvm.app.controller('EnvCtrl', ['$scope', '$routeParams', function($scope, $routeParams) {
		$scope.data = phalconvm.data[$routeParams.service] = phalconvm.data[$routeParams.service] || {};
	}]);
})(angular, phalconvm);