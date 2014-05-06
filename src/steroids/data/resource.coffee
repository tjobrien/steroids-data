ramlSchemaFromFile = steroids.data.schema.raml.fromFile
ramlSchemaToResource = steroids.data.resources.raml

schema = do ->
  localSchema = '//localhost/local.raml'
  cloudSchema = '//localhost/cloud.raml'

  ramlSchemaFromFile(localSchema).error ->
    ramlSchemaFromFile(cloudSchema)


class ResourceProxy
  proxy = (method) -> (args...) ->
    @resource.then (res) ->
      res[method](args...)

  constructor: (@resource) ->

  findAll: proxy 'findAll'
  create: proxy 'create'
  find: proxy 'find'
  update: proxy 'update'
  remove: proxy 'remove'


module.exports = resourceByName = (name) ->
  new ResourceProxy (schema.then ramlSchemaToResource name)