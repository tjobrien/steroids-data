restful = require './restful'
types = require '../types'

module.exports = ramlResourceFromSchema = (schema) ->
  restful {
    baseUrl: schema.baseUri
  }, (api) ->
    actions = {}

    for resource in schema.resources
      do (relativeUri = resource.relativeUri) ->
        for action in resource.actions
          actions[action.description] = api[action.method]
            from: -> relativeUri
            expect: types.Any
            through: types.Project.Identity

    actions
