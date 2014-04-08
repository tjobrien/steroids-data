module.exports = (grunt) ->
  grunt.registerTask 'build', [
    'clean'
    'coffeelint'
    'browserify'
  ]
