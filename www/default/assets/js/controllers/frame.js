(function(phalconvm) {
	phalconvm.app.controller('FrameCtrl', ['$rootScope', '$routeParams', function($rootScope, $routeParams) {
		var key = '/iframe' + encodeURIComponent($routeParams.href).split('%2F').join('/');

		$rootScope.saveButton = false;
		$rootScope.title = false;

		if (phalconvm.menu.miscellaneous[key]) {
			$rootScope.title = phalconvm.menu.miscellaneous[key].label;
		} else if (phalconvm.menu.tools[key]) {
			$rootScope.title = phalconvm.menu.tools[key].label;
		}
	}]);
})(phalconvm);