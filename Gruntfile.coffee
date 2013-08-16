module.exports = (grunt) ->

	grunt.initConfig {
		mochacli: {
			options: {
				require: ['chai', 'sinon']
				compilers: ['coffee:coffee-script']
				files: 'test/test.coffee'
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
		}

		watch: {
			coffee: {
				files: 'src/coffee/*.coffee'
				tasks: 'coffee'
			}

			mocha: {
				files: 'test/*.coffee'
				tasks: 'test-watch'
			}
		}
		
		coffee: {
			compile: {
				options: {
					join: true
					basePath: 'src/coffee'
				}
				src: ['src/coffee/elements.coffee', 'src/coffee/person.coffee', 'src/coffee/tile.coffee', 'src/coffee/building.coffee', 'src/coffee/world.coffee' ]
				dest: 'js/main.js'
			}
		}

		test: {
			
		}

		copy: {
			target: {
				files:
					'prod/' : ['dev/**']
			}
		}

		lint: {
			files: [
				'js/main.js'
			]
		}

		jshint: {
			options: {
				curly: true,
				eqeqeq: true,
				immed: true,
				latedef: true,
				newcap: true,
				noarg: true,
				sub: true,
				undef: true,
				boss: true,
				eqnull: true,
				browser: true
			},
			globals: {
				jQuery: true
			}
		}

	}

	grunt.registerTask 'default', 'Log some stuff.', ->
		grunt.log.write('available tasks: coffee, watch, test, test-watch')


	grunt.registerTask 'coffee', ['coffee']
	grunt.registerTask 'test', ['mochacli:single']
	grunt.registerTask 'test-watch', ['mochacli:watching']

	grunt.loadNpmTasks 'grunt-contrib-coffee'
	grunt.loadNpmTasks 'grunt-mocha-cli'
	grunt.loadNpmTasks 'grunt-contrib-watch'


