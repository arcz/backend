module.exports = (grunt) ->
  require('time-grunt') grunt
  require('load-grunt-tasks') grunt

  # configurable paths
  paths =
    app: 'app'

  grunt.registerTask 'server', [
    'copy',
    'compass',
    'autoprefixer',
    'concurrent:dev'
  ]

  grunt.registerTask 'default', [ 'server' ]

  grunt.initConfig
    path: paths
    watch:
      compass:
        files: ['<%= path.app %>/styles/{,*/}*.{scss,sass}']
        tasks: ['compass:server', 'autoprefixer']

      server:
        files: ['./{,*/}*']
        tasks: ['express:dev']
        options:
          # Without this option specified express won't be reloaded
          spawn: false

    express:
      options:
        port: '3000'

      dev:
        options:
          script: './server'
          opts: [ 'node_modules/coffee-script/bin/coffee' ]
          debug: false
          background: false
          node_env: 'development'

    clean:
      dist: [ '.tmp' ]

    compass:
      options:
        sassDir: '<%= path.app %>/styles'
        cssDir: '<%= path.app %>/styles'
        # generatedImagesDir: '.tmp/images/generated',
        # imagesDir: '<%= yeoman.app %>/images',
        # javascriptsDir: '<%= yeoman.app %>/scripts',
        # fontsDir: '<%= yeoman.app %>/styles/fonts',
        # importPath: '<%= yeoman.app %>/bower_components',
        httpImagesPath: '/images'
        httpGeneratedImagesPath: '/images/generated'
        httpFontsPath: '/styles/fonts'
        relativeAssets: false

    autoprefixer:
      options:
        browsers: ['last 1 version']
      dist:
        files: [
          {
            expand: true
            cwd: '<%= path.app %>/styles/'
            src: '{,*/}*.css'
            # dest: '.tmp/styles/'
          }
        ]

    concurrent:
      dev:
        tasks: [ 'watch', 'express:dev' ]
        options: logConcurrentOutput: true

    copy:
      fonts:
        expand: true
        dot: true
        cwd: '<%= path.app %>/bower_components/font-awesome/font'
        dest: '<%= path.app %>/styles/font'
        src: '{,*/}*.*'

