(function(phalconvm) {
	var controller = function($rootScope, $routeParams, $mdDialog, $http) {
		var self = this,
			data = phalconvm.menu.sites['/site/' + $routeParams.site] || false;

		if (!data || $rootScope.newSite) {
			data = {
				label: '',
				directory: '',
				domains: '',
				repository: '',
				provider: ''
			};
		}

		$rootScope.title = data.label;
		$rootScope.saveButton = false;

		self.data = data;
		self.providers = [
			{key: 'git', label: 'Git'},
			{key: 'bzr', label: 'Bazaar'},
			{key: 'cvs', label: 'CVS'},
			{key: 'hg',  label: 'Mercurial'},
			{key: 'p4',  label: 'Perforce'},
			{key: 'svn', label: 'Subversion'}
		];

		self.save = function() {
			$rootScope.newSite = false;

			if (angular.isArray(phalconvm.menu.sites)) {
				phalconvm.menu.sites = {};
			}

			phalconvm.menu.sites['/site/' + self.data.directory] = self.data;
			$http.post('/save/site', self.data);

			$mdDialog.hide();
		};

		self.cancel = function() {
			$rootScope.newSite = false;
			$mdDialog.cancel();
		};
	};

	phalconvm.app.controller('SiteCtrl', ['$rootScope', '$routeParams', '$mdDialog', '$http', controller]);
})(phalconvm);
