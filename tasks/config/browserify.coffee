module.exports =
  options:
    browserifyOptions:
      extensions: ['.coffee']
    transform: ['coffeeify']
 
  dist:
    src: '<%= dir.src %>/steroids/data.coffee'
    dest: '<%= dir.dist %>/steroids.data.js'
