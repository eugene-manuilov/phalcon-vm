const EnvController = ['$scope', '$rootScope', '$routeParams', function($scope, $rootScope, $routeParams) {
	$rootScope.title = phalconvm.menu.environment['/env/' + $routeParams.service].label;
	$rootScope.saveButton = true;

	$scope.data = phalconvm.data;
}];

export default EnvController;