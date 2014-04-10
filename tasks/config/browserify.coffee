module.exports =
  options:
    transform: ['coffeeify']
    browserifyOptions:
      extensions: ['.coffee']
    bundleOptions:
      standalone: 'steroids.data'
 
  dist:
    src: '<%= dir.src %>/steroids/data.coffee'
    dest: '<%= dir.dist %>/steroids.data.js'
