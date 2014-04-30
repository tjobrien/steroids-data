_ = require 'lodash'
restful = require './restful'
types = require '../types'

uriToFunction = (uri) ->
  uriTemplate = _.template(uri, null, interpolate: /{([\s\S]+?)}/g)
  (id) ->
    uriTemplate {id}


module.exports = ramlResourceFromSchema = (resourceName, schema) ->
  restful {
    baseUrl: schema.baseUri
  }, (api) ->
    actions = {}

    for name, {relativeUri, action} of schema.resource(resourceName).actionsByName()
      actions[name] = api[action.method]
        path: uriToFunction relativeUri
        expect: types.Any
        through: types.Project.Identity
        options:
          headers: action.headerDefaults()

    actions
