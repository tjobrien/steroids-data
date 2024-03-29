_ = require 'lodash'
restful = require './restful'
types = require '../types'

uriToFunction = (uri) ->
  uriTemplate = _.template(uri, null, interpolate: /{([\s\S]+?)}/g)
  (id) ->
    uriTemplate {id}

responseValidationsForAction = do ->
  typeByRootKey = (rootKey) ->
    if rootKey
      [head, tail...] = rootKey.split '.'
      if tail.length
        types.Property head, typeByRootKey tail.join '.'
      else
        types.Property head
    else
      types.Any

  (action) ->
    if !action.responses.length
      return types.Any

    _.object (
      for response in action.responses
        [
          response.code
          typeByRootKey response.metadata.rootKey
        ]
    )

requestValidationForAction = (action) ->
  if action.metadata.rootKey?
    types.projections.Property action.metadata.rootKey
  else
    types.Any

module.exports = ramlResourceFromSchema = (resourceName) -> (schema) ->
  restful {
    baseUrl: schema.baseUri
  }, (api) ->
    actions = {}

    for name, {relativeUri, action} of schema.resource(resourceName).actionsByName()
      actions[name] = api[action.method]
        path: uriToFunction relativeUri
        send: api.request requestValidationForAction action
        receive: api.response responseValidationsForAction action
        options:
          headers: action.headerDefaults()

    actions
