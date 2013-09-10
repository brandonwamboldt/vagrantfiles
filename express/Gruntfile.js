'use strict';

module.exports = function (grunt) {
  grunt.initConfig({
    pkg    : grunt.file.readJSON('package.json'),
    nodemon: {
      prod: {
        options: {
          legacyWatch: true,
          file: 'app/server.js',
          env: {
            NODE_ENV: 'development'
          }
        }
      }
    }
  });

  // NPM Tasks
  grunt.loadNpmTasks('grunt-contrib-clean');
  grunt.loadNpmTasks('grunt-nodemon');

  // Aliases
  grunt.registerTask('server', ['nodemon'])
};
