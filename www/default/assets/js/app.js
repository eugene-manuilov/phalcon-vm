const AppController = ['$rootScope', '$mdSidenav', '$mdDialog', '$http', function ($rootScope, $mdSidenav, $mdDialog, $http) {
	const self = this;

	self.nasty = false;
	self.menu = phalconvm.menu;
	self.data = phalconvm.data;

	self.setNasty = function() {
		self.nasty = true;
	};

	self.saveChanges = function() {
		const alert = $mdDialog.alert()
			.clickOutsideToClose(true)
			.title('Saved changes')
			.htmlContent('Changes have been saved. Please, do not forget to halt your vagrant box<br>and up it again with <b>--provision</b> mode.')
			.ok('Got it!');

		self.nasty = false;

		$http.post('/save/env', phalconvm.data);
		$mdDialog.show(alert);
	};

	self.toggleSidenav = function() {
		$mdSidenav('left').toggle();
	};

	self.newSiteDialog = function() {
		$rootScope.newSite = true;

		$mdDialog.show({
			controller: 'SiteCtrl',
			controllerAs: 'site',
			template: document.getElementById('tmpl-new-site').innerHTML
		}).then(function() {
			self.setNasty();
		});
	};
}];

export default AppController;