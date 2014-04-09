module.exports = (grunt) ->
  grunt.registerTask 'dev', [
    'connect:test'
    'test'
    'watch:test'
  ]