module.exports = (grunt) ->
  require('time-grunt') grunt
  require('load-grunt-tasks') grunt

  # configurable paths
  paths =
    server : 'server'
    dist   : 'dist'

  grunt.registerTask 'default', [ 'server' ]
  grunt.registerTask 'test', [ 'mochacov:spec', 'mochacov:it' ]
  grunt.registerTask 'test:spec', [ 'mochacov:spec' ]
  grunt.registerTask 'test:it', [ 'mochacov:it' ]
  grunt.registerTask 'lint', [ 'coffeelint' ]
  grunt.registerTask 'server', [ 'concurrent:dev' ]


  grunt.initConfig
    path: paths

    concurrent:
      options: logConcurrentOutput: true
      dev:
        tasks: [
          'nodemon:dev'
          'watch:server'
        ]

    watch:
      server:
        files: ['**/*.coffee', '!node_modules/**/*' ]
        tasks: [ 'mochacov:spec', 'mochacov:it' ]

    # Using nodemon to restart the express server for each backend change
    nodemon:
      dev:
        script: 'server/index.coffee'
        options:
          ignore: ['node_modules/**', '<%= path.dist %>/**/*']
          ext: 'coffee'
          env: node_env: 'development'

    clean: dist: [ '<%= path.dist %>' ]

    mochacov :
      options :
        files     : [ 'test/**/*.spec.coffee', 'test/**/*.it.coffee' ]
        compilers : [ 'coffee:coffee-script/register' ]
        require   : [ 'should' ]
        growl     : true
        ui        : 'tdd'
        bail      : true # Fail fast
      travis :
        options : coveralls : serviceName : 'travis-ci'
      spec :
        options :
          reporter : 'spec'
          files: [ 'test/**/*.spec.coffee' ]
      it:
        options :
          reporter : 'spec'
          files: [ 'test/**/*.it.coffee' ]
      cov  :
        options : reporter : 'html-cov'

    coffeelint:
      options: configFile: 'coffeelint.json'
      files: [ '**/*.coffee', '!node_modules/**/*' ]
