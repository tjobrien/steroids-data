/*
 * Default Gruntfile for AppGyver Steroids
 * http://www.appgyver.com
 *
 * Licensed under the MIT license.
 */

'use strict';

module.exports = function(grunt) {

  grunt.loadNpmTasks("grunt-steroids");
  grunt.loadNpmTasks("grunt-contrib-copy");

  grunt.initConfig({
    copy: {
      "steroids-data-dist": {
        src: "../dist/*",
        dest: "dist/"
      }
    }
  });

  grunt.registerTask("default", [
    "steroids-make",
    "steroids-compile-sass",
    "copy"
  ]);
};
