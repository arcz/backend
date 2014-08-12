// Generated on 2013-09-15 using generator-webapp 0.4.2
'use strict';

// # Globbing
// for performance reasons we're only matching one level down:
// 'test/spec/{,*/}*.js'
// use this if you want to recursively match all subfolders:
// 'test/spec/**/*.js'

module.exports = function (grunt) {
  // show elapsed time at the end
  require('time-grunt')(grunt);
  // load all grunt tasks
  require('load-grunt-tasks')(grunt);

  // configurable paths
  var paths = {
    app: 'app',
  };

  grunt.initConfig({
    path: paths,
    watch: {
      compass: {
        files: ['<%= path.app %>/styles/{,*/}*.{scss,sass}'],
        tasks: ['compass:server', 'autoprefixer']
      },
      server: {
        files: ['./{,*/}*'],
        tasks: ['express:dev'],
        options: {
          spawn: false //Without this option specified express won't be reloaded
        }
      },
    },

    express: {
      options: {
        port: '3000'
      },
      dev: {
        options: {
          script: './server',
          opts: [ 'node_modules/coffee-script/bin/coffee' ],
          debug: false,
          background: false,
          node_env: 'development'
        }
      }
    },

    clean: {
      dist: [ '.tmp' ]
    },

    // coffee: {
    //   dist: {
    //     files: [
    //       {
    //         expand: true,
    //         src: [ '**/*.coffee', '!node_modules/**', '!**/bower_components/**'],
    //         dest: '.tmp',
    //         ext: '.js'
    //       }
    //     ]
    //   },
    // },

    compass: {
      options: {
        sassDir: '<%= path.app %>/styles',
        cssDir: '<%= path.app %>/styles',
        // generatedImagesDir: '.tmp/images/generated',
        // imagesDir: '<%= yeoman.app %>/images',
        // javascriptsDir: '<%= yeoman.app %>/scripts',
        // fontsDir: '<%= yeoman.app %>/styles/fonts',
        // importPath: '<%= yeoman.app %>/bower_components',
        httpImagesPath: '/images',
        httpGeneratedImagesPath: '/images/generated',
        httpFontsPath: '/styles/fonts',
        relativeAssets: false
      }
    },

    autoprefixer: {
      options: {
        browsers: ['last 1 version']
      },
      dist: {
        files: [
          {
            expand: true,
            cwd: '<%= path.app %>/styles/',
            src: '{,*/}*.css'
            // dest: '.tmp/styles/'
          }
        ]
      }
    },

    concurrent: {
      dev: {
        tasks: [ 'watch', 'express:dev' ],
        options: {
          logConcurrentOutput: true
        }
      }
    },

    copy: {
      fonts: {
        expand: true,
        dot: true,
        cwd: '<%= path.app %>/bower_components/font-awesome/font',
        dest: '<%= path.app %>/styles/font',
        src: '{,*/}*.*'
      }
    }
  });

  grunt.registerTask('server', function (target) {
    grunt.task.run([
      'copy',
      'compass',
      'autoprefixer',
      'concurrent:dev'
    ]);
  });

  grunt.registerTask('default', [ 'server' ]);
};
