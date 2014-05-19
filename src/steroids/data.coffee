
module.exports =
  ajax: require './data/ajax'
  types: require './data/types'
  reactive: require './data/reactive'
  resource: require './data/resource'
  resources:
    restful: require './data/resources/restful'
    builtio: require './data/resources/builtio'
    raml: require './data/resources/raml'
  schema:
    json: require './data/schema/json'
    raml: require './data/schema/raml'
  service: require './data/service'
  storage: require './data/storage'