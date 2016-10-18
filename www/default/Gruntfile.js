module.exports = function(grunt) {
	require('matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks);

	grunt.initConfig({
		pkg: grunt.file.readJSON('package.json'),
		concat: {
			scripts: {
				files: {
					'public/js/app.js': [
						'bower_components/angular/angular.js',
						'bower_components/angular-animate/angular-animate.js',
						'bower_components/angular-aria/angular-aria.js',
						'bower_components/angular-messages/angular-messages.js',
						'bower_components/angular-material/angular-material.js',
						'assets/js/application.js'
					]
				}
			}
		},
		jshint: {
			all: ['assets/js/**/*.js'],
			options: {
				curly: true,
				eqeqeq: false,
				immed: true,
				latedef: true,
				newcap: true,
				noarg: true,
				sub: true,
				undef: true,
				boss: true,
				eqnull: true,
				globals: {
					window: false,
					document: false,
					console: false,
					angular: false
				}
			}
		},
		sass: {
			options: {
				sourceMap: true,
				precision: 5,
				outputStyle: 'compressed'
			},
			all: {
				files: {
					'public/css/app.css': 'assets/css/app.scss'
				}
			}
		}
	});

	// Default tasks
	grunt.registerTask('css', ['sass']);
	grunt.registerTask('js', ['jshint', 'concat']);
	grunt.registerTask('default', ['js', 'css']);

	grunt.util.linefeed = '\n';
};