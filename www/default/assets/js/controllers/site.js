(function(phalconvm) {
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
			if (angular.isArray(phalconvm.menu.sites)) {
				phalconvm.menu.sites = {};
			}

			phalconvm.menu.sites['/site/' + self.directory] = {
				label: self.name,
				directory: self.directory,
				domains: self.domains,
				repository: self.repository,
				provider: self.provider
			};

			$mdDialog.hide();
		};

		self.cancel = function() {
			$mdDialog.cancel();
		};
	}]);
})(phalconvm);