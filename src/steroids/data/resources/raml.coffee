_ = require 'lodash'
restful = require './restful'
types = require '../types'

uriToFunction = (uri) ->
  uriTemplate = _.template(uri, null, interpolate: /{([\s\S]+?)}/g)
  (id) ->
    uriTemplate {id}


module.exports = ramlResourceFromSchema = (resourceName) -> (schema) ->
  restful {
    baseUrl: schema.baseUri
  }, (api) ->
    actions = {}

    for name, {relativeUri, action} of schema.resource(resourceName).actionsByName()
      actions[name] = api[action.method]
        path: uriToFunction relativeUri
        receive: api.response _.object (
          for response in action.responses
            [
              response.code
              if response.metadata.rootKey
                types.Property response.metadata.rootKey
              else
                types.Any
            ]
        )
        options:
          headers: action.headerDefaults()

    actions
