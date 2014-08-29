module.exports = (grunt) ->
  require('time-grunt') grunt
  require('load-grunt-tasks') grunt

  # configurable paths
  paths =
    app    : 'app'
    server : 'server'

  grunt.registerTask 'test', [ 'mochacov:spec', 'mochacov:it' ]
  grunt.registerTask 'test:spec', [ 'mochacov:spec' ]
  grunt.registerTask 'test:it', [ 'mochacov:it' ]
  grunt.registerTask 'lint', [ 'coffeelint' ]
  grunt.registerTask 'server', [
    'copy'
    'compass'
    'nodemon:dev'
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

    nodemon:
      dev:
        script: 'server/index.coffee'
        options:
          ignore: ['./node_modules/**', './app/bower_components/**']
          ext: 'coffee'
          env:
            node_env: 'development'

    clean: dist: [ '.tmp' ]

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
      files: [ '**/*.coffee', '!node_modules/**/*', '!app/bower_components/**/*' ]
