module.exports = (grunt) ->
  require('time-grunt') grunt
  require('load-grunt-tasks') grunt

  # configurable paths
  paths =
    app    : 'app'
    server : 'server'
    dist   : 'dist'

  grunt.registerTask 'default', [ 'server' ]
  grunt.registerTask 'test', [ 'mochacov:spec', 'mochacov:it' ]
  grunt.registerTask 'test:spec', [ 'mochacov:spec' ]
  grunt.registerTask 'test:it', [ 'mochacov:it' ]
  grunt.registerTask 'lint', [ 'coffeelint' ]
  grunt.registerTask 'build', [ 'clean', 'browserify:dist', 'copy' ]
  grunt.registerTask 'server', [
    'clean'
    'symlink'
    'concurrent:dev'
  ]


  grunt.initConfig
    path: paths

    concurrent:
      options: logConcurrentOutput: true
      dev:
        tasks: [
          'nodemon:dev'
          'compass:dev'
          'browserify:dev'
          'watch:test'
        ]

    watch:
      test:
        files: ['**/*.coffee', '!node_modules/**/*', '!<%= path.app %>/vendor/**/*']
        tasks: ['test']

    # Using nodemon to restart the express server for each backend change
    nodemon:
      dev:
        script: 'server/index.coffee'
        options:
          ignore: ['node_modules/**', '<%= path.app %>/**/*', '<%= path.dist %>/**/*']
          ext: 'coffee'
          env: node_env: 'development'

    clean: dist: [ '<%= path.dist %>' ]

    compass:
      options:
        sassDir: '<%= path.app %>/styles'
        cssDir: '<%= path.app %>/styles'
      dev:
        options: watch: true
      files: 'main.scss'

    # For release we copy the files instead
    copy:
      build:
        expand: true
        cwd: '<%= path.app %>'
        src: [
          'index.html'
          'styles/main.css'
        ]
        dest: '<%= path.dist %>'
      fonts:
        src: '<%= path.app %>/vendor/fontawesome/fonts'
        dest: '<%= path.dist %>/fonts'

    # For development mode we symlink the index.html and stylesheet files
    symlink:
      options: overwrite: true
      dev:
        expand: true
        cwd: '<%= path.app %>'
        src: [
          'index.html'
          'styles/main.css'
        ]
        dest: '<%= path.dist %>'
      fonts:
        src: '<%= path.app %>/vendor/fontawesome/fonts'
        dest: '<%= path.dist %>/fonts'

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
      files: [ '**/*.coffee', '!node_modules/**/*', '!<%= path.app %>/vendor/**/*' ]

    browserify:
      options:
        watch     : false
        keepAlive : false
        transform : [
          'coffeeify'
          'debowerify'
        ]

      dev:
        options:
          watch     : true
          keepAlive : true
        files:
          '<%= path.dist %>/scripts/main.js': [ '<%= path.app %>/scripts/main.coffee' ]

      dist:
        files:
          '<%= path.dist %>/scripts/main.js': [ '<%= path.app %>/scripts/main.coffee' ]
