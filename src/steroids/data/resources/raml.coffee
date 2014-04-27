_ = require 'lodash'
restful = require './restful'
types = require '../types'

uriToFunction = (uri) ->
  uriTemplate = _.template(uri, null, interpolate: /{([\s\S]+?)}/g)
  (id) ->
    uriTemplate {id}


module.exports = ramlResourceFromSchema = (schema) ->
  restful {
    baseUrl: schema.baseUri
  }, (api) ->
    actions = {}

    for resource in schema.resources
      do (relativeUri = resource.relativeUri) ->
        for action in resource.actions
          actions[action.description] = api[action.method]
            from: uriToFunction relativeUri
            expect: types.Any
            through: types.Project.Identity

    actions
