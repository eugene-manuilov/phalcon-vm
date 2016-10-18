(function(angular) {
	var phalconvm = angular.module('PhalconVM', ['ngMaterial']);

	phalconvm.controller('AppCtrl', function ($scope, $mdMedia, $mdSidenav) {
		$scope.toggleSidenav = function() {
			$mdSidenav('left').toggle();
		};
	});
})(angular);