(function(phalconvm) {
	phalconvm.app.controller('AppCtrl', ['$mdSidenav', '$mdDialog', '$http', function ($mdSidenav, $mdDialog, $http) {
		var self = this;

		self.nasty = false;
		self.menu = phalconvm.menu;

		self.setNasty = function() {
			self.nasty = true;
		};

		self.saveChanges = function() {
			var alert;

			alert = $mdDialog.alert()
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
			$mdDialog.show({
				controller: 'SiteCtrl',
				controllerAs: 'site',
				template: document.getElementById('tmpl-new-site').innerHTML
			});
		};
	}]);
})(phalconvm);