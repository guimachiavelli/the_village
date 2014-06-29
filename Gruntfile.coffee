module.exports = (grunt) ->

	grunt.initConfig
		mochacli:
			options: {
				compilers: ['coffee:coffee-script/register']
				files: 'test/*.coffee',
				'check-leaks':  true
			}

			single: {
				options: {
					reporter: 'spec'
				}
			}

			watching: {
				options: {
					reporter: 'min'
				}
			}

		watch:
			mocha: {
				files: ['test/*.coffee', 'lib/*.coffee']
				tasks: ['mochacli:watching']
			}

	grunt.registerTask 'default', 'Log some stuff.', ->
		grunt.log.write 'available tasks: test, watch'


	grunt.registerTask 'test', ['mochacli:single']

	grunt.loadNpmTasks 'grunt-contrib-coffee'
	grunt.loadNpmTasks 'grunt-mocha-cli'
	grunt.loadNpmTasks 'grunt-contrib-watch'
