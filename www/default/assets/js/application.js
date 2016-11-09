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

		self.newSiteDialog = function() {
			$mdDialog.show({
				controller: 'SiteCtrl',
				controllerAs: 'site',
				template: document.getElementById('tmpl-new-site').innerHTML
			});
		};
	}]);

	phalconvm.app.controller('HomeCtrl', ['$rootScope', function($rootScope) {
		$rootScope.saveButton = false;
		$rootScope.title = 'Introduction';
	}]);

	phalconvm.app.controller('SiteCtrl', ['$mdDialog', function($mdDialog) {
		var self = this;

		self.name = '';
		self.directory = '';
		self.domains = '';
		self.repository = '';
		self.provider = '';

		self.providers = [
			{key: 'git', label: 'Git'},
			{key: 'bzr', label: 'Bazaar'},
			{key: 'cvs', label: 'CVS'},
			{key: 'hg',  label: 'Mercurial'},
			{key: 'p4',  label: 'Perforce'},
			{key: 'svn', label: 'Subversion'}
		];

		self.create = function() {
			$mdDialog.hide();
		};

		self.cancel = function() {
			$mdDialog.cancel();
		};
	}]);

	phalconvm.app.controller('EnvCtrl', ['$scope', '$rootScope', '$routeParams', function($scope, $rootScope, $routeParams) {
		$rootScope.title = phalconvm.menu.environment['/env/' + $routeParams.service].label;
		$rootScope.saveButton = true;

		$scope.data = phalconvm.data;
	}]);

	phalconvm.app.controller('FrameCtrl', ['$scope', '$rootScope', '$routeParams', function($scope, $rootScope, $routeParams) {
		var key = '/iframe' + encodeURIComponent($routeParams.href).split('%2F').join('/');

		$rootScope.saveButton = false;
		$rootScope.title = false;

		if (phalconvm.menu.miscellaneous[key]) {
			$rootScope.title = phalconvm.menu.miscellaneous[key].label;
		} else if (phalconvm.menu.tools[key]) {
			$rootScope.title = phalconvm.menu.tools[key].label;
		}
	}]);
})(angular, phalconvm, document);
