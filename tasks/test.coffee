module.exports = (grunt) ->
  grunt.registerTask 'test', ->
    # Pass cli flags to mochaTest options because they aren't used automatically
    grunt.config.set 'mochaTest.options',
      grep: grunt.option('grep'),
      invert: grunt.option('invert') || false

    grunt.task.run 'mochaTest'