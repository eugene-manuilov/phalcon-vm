const download = function(filename, text) {
	var element = document.createElement('a');

	element.setAttribute('href', 'data:application/json;charset=utf-8,' + encodeURIComponent(text));
	element.setAttribute('download', filename);

	element.style.display = 'none';
	document.body.appendChild(element);

	element.click();

	document.body.removeChild(element);
};

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

	self.exportSettings = function() {
		download('settings.json', JSON.stringify(Object.assign({}, phalconvm.data, {sites: {}})));
	};

	$rootScope.importSettings = function(input) {
		const reader = new FileReader();

		reader.onload = function() {
			let alert = false;

			try {
				const data = JSON.parse(reader.result);
				for (const group in data) {
					if ('sites' !== group) {
						for (const item in data[group]) {
							phalconvm.data[group][item] = data[group][item];
						}
					}
				}

				self.nasty = true;

				alert = $mdDialog
					.alert()
					.title('Settings imported')
					.htmlContent('Settings has been imported. You need to save it by clicking "Save Changes" button in the toolbar.');
			} catch(e) {
				alert = $mdDialog
					.alert()
					.title('Import failed')
					.htmlContent(e);
			}

			if (alert) {
				alert.clickOutsideToClose(true);
				alert.ok('Got it!');

				$mdDialog.show(alert);
			}

			input.value = '';
		};

		if (input.files.length > 0) {
			reader.readAsText(input.files[0]);
		}
	};

	self.selectFile = function() {
		document.getElementById('settings-file').click();
	};
}];

export default AppController;