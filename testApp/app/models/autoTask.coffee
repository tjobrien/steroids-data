{fromFile} = steroids.data.schema.raml 
ramlResource = steroids.data.resources.raml

AutoTaskResource = fromFile('//localhost/models/resources/Task.raml').then ramlResource

angular
  .module('TaskModel', [])
  .constant('AutoTaskResource', AutoTaskResource)
