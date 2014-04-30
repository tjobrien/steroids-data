module.exports =
  build:
    files: [
      '<%= dir.src %>/**/*.coffee'
    ]
    tasks: 'build'
  test:
    files: [
      '<%= dir.src %>/**/*.coffee'
      '<%= dir.test %>/**/*Spec.coffee'
      '<%= dir.test %>/data/**/*.*'
    ]
    tasks: [
      'coffeelint'
      'test'
    ]