export default function getHomeController() {
	return ['$rootScope', function($rootScope) {
		$rootScope.saveButton = false;
		$rootScope.title = 'Introduction';
	}];
}