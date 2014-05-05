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
        receive: api.response types.Any
        options:
          headers: action.headerDefaults()

    actions
