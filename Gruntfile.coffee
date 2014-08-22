module.exports = (grunt) ->
  require('time-grunt') grunt
  require('load-grunt-tasks') grunt

  # configurable paths
  paths =
    app    : 'app'
    server : 'server'

  grunt.registerTask 'test', [ 'lint', 'mochacov:spec' ]
  grunt.registerTask 'lint', [ 'coffeelint' ]
  grunt.registerTask 'server', [
    'copy'
    'compass'
    'express:dev'
    'watch'
  ]

  grunt.registerTask 'default', [ 'server' ]

  grunt.initConfig
    path: paths
    watch:
      compass:
        files: ['<%= path.app %>/styles/{,*/}*.{scss,sass}']
        tasks: ['compass']

      test:
        files: ['**/*.coffee', '!node_modules/**/*', '!app/bower_components/**/*']
        tasks: ['test']

      server:
        files: ['<%= path.server %>/**/*']
        tasks: ['express:dev']
        options:
          # Without this option specified express won't be reloaded
          spawn: true

    express:
      options:
        port: '3000'

      dev:
        options:
          script: './server'
          opts: [ 'node_modules/coffee-script/bin/coffee' ]
          debug: false
          background: true
          node_env: 'development'

    clean:
      dist: [ '.tmp' ]

    compass:
      options:
        sassDir: '<%= path.app %>/styles'
        cssDir: '<%= path.app %>/styles'
      files:
        '<%= path.app %>/styles/main.css': 'main.scss'

    copy:
      fonts:
        expand: true
        dot: true
        cwd: '<%= path.app %>/bower_components/font-awesome/font'
        dest: '<%= path.app %>/font'
        src: '{,*/}*.*'

    mochacov :
      travis :
        options : coveralls : serviceName : 'travis-ci'
      spec :
        options : reporter : 'spec'
      cov  :
        options : reporter : 'html-cov'
      options :
        compilers : [ 'coffee:coffee-script/register' ]
        files     : [ 'test/**/*.spec.coffee' ]
        require   : [ 'should' ]
        growl     : true
        ui        : 'tdd'
        bail      : true # Fail fast

    coffeelint:
      options: configFile: 'coffeelint.json'
      files: [ '**/*.coffee', '!node_modules/**/*', '!app/bower_components/**/*' ]
