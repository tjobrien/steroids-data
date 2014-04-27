ramlSchemaFromFile = steroids.data.schema.raml.fromFile
ramlSchemaToResource = steroids.data.resources.raml

AutoTaskResource = ramlSchemaFromFile('//localhost/resources/Task.raml').then ramlSchemaToResource

angular
  .module('TaskModel', [])
  .constant('AutoTaskResource', AutoTaskResource)
