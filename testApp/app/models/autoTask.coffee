ramlSchemaFromFile = steroids.data.schema.raml.fromFile
ramlSchemaToResource = steroids.data.resources.raml

AutoTaskResource = ramlSchemaFromFile('//localhost/resources.raml')
  .then ramlSchemaToResource('task')

angular
  .module('TaskModel', [])
  .constant('AutoTaskResource', AutoTaskResource)
