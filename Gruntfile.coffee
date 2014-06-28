module.exports = (grunt) ->

	grunt.initConfig
		mochacli:
			options: {
				compilers: ['coffee:coffee-script/register']
				files: 'test/*.coffee'
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
				tasks: ['test-watch', 'lint']
			}

	grunt.registerTask 'default', 'Log some stuff.', ->
		grunt.log.write 'available tasks: test, watch'


	grunt.registerTask 'test', ['mochacli:single']
	grunt.registerTask 'test-watch', ['mochacli:watching']

	grunt.loadNpmTasks 'grunt-contrib-coffee'
	grunt.loadNpmTasks 'grunt-mocha-cli'
	grunt.loadNpmTasks 'grunt-contrib-watch'
