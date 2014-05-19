ramlSchemaFromFile = require('./schema/raml').fromFile
ramlSchemaToResource = require './resources/raml'

# TODO: Remove duplication - this is identical to what's in resource.coffee
schema = do ->
  localSchema = '//localhost/local.raml'
  cloudSchema = '//localhost/cloud.raml'

  ramlSchemaFromFile(localSchema).catch ->
    ramlSchemaFromFile(cloudSchema)

# Returns a function that calls the method 'invoke' on a resource interpreted from a raml schema
module.exports = serviceByName = (name) ->
  (args...) ->
    (schema.then ramlSchemaToResource name)
      .then (resource) ->
        resource.invoke args...