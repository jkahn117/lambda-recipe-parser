module.exports = (grunt) ->
	grunt.initConfig
		lambda_invoke:
			default:
				options:
					file_name: 'index.js',
					event: 'event.json'
		lambda_deploy:
			default:
				arn: '<YOUR_LAMBDA_ARN>'
				options:
					profile: 'lambda'
					region:  '<YOUR_LAMBDA_REGION>'
					#enableVersioning: true
		lambda_package:
			default: {}
		coffee:
			# compile all CoffeeScript files to a single JS file, index.js
			options:
				join: true
			compile:
				files:
					'index.js': [ 'src/*.coffee', 'src/parsers/*.coffee' ]
	grunt.loadNpmTasks('grunt-contrib-coffee')
	grunt.loadNpmTasks('grunt-aws-lambda')

	# simplify packaging and deployment
	grunt.registerTask('package', [ 'coffee', 'lambda_package' ])
	grunt.registerTask('invoke', [ 'coffee', 'lambda_invoke' ])
	grunt.registerTask('deploy', [ 'package', 'lambda_deploy' ])
