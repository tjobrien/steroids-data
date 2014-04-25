
module.exports =
  ajax: require './data/ajax'
  types: require './data/types'
  resources:
    restful: require './data/resources/restful'
    builtio: require './data/resources/builtio'
  schema:
    json: require './data/schema/json'
    raml: require './data/schema/raml'