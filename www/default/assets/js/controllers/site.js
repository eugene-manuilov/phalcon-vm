(function(phalconvm) {
	var controller = function($rootScope, $routeParams, $mdDialog) {
		var self = this,
			data = {};

		$rootScope.saveButton = true;

		if ($rootScope.newSite) {
			data = {
				label: '',
				directory: '',
				domains: '',
				repository: '',
				provider: ''
			};
		} else {
			angular.forEach(phalconvm.data.sites, function(site) {
				if (site.directory == $routeParams.site) {
					data = site;
				}
			});

			$rootScope.title = data.label;
		}

		self.data = data;
		self.providers = [
			{key: 'git', label: 'Git'},
			{key: 'bzr', label: 'Bazaar'},
			{key: 'cvs', label: 'CVS'},
			{key: 'hg',  label: 'Mercurial'},
			{key: 'p4',  label: 'Perforce'},
			{key: 'svn', label: 'Subversion'}
		];

		self.add = function() {
			if (!angular.isArray(phalconvm.data.sites)) {
				phalconvm.data.sites = [];
			}

			phalconvm.data.sites.push({
				label: self.data.label,
				directory: self.data.directory,
				domains: self.data.domains,
				repository: self.data.repository,
				provider: self.data.provider
			});

			$rootScope.newSite = false;
			$mdDialog.hide();
		};

		self.cancel = function() {
			$rootScope.newSite = false;
			$mdDialog.cancel();
		};
	};

	phalconvm.app.controller('SiteCtrl', ['$rootScope', '$routeParams', '$mdDialog', controller]);
})(phalconvm);
