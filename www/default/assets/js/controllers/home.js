(function(phalconvm) {
	phalconvm.app.controller('HomeCtrl', ['$rootScope', function($rootScope) {
		$rootScope.saveButton = false;
		$rootScope.title = 'Introduction';
	}]);
})(phalconvm);