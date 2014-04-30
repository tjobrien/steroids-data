module.exports = (grunt) ->
  grunt.registerTask 'dev', [
    'connect:test'
    'coffeelint'
    'test'
    'watch:test'
  ]