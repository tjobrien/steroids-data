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

    for relativeUri, action of schema.actions()
      actions[action.metadata.name] = api[action.method]
        path: uriToFunction relativeUri
        expect: types.Any
        through: types.Project.Identity
        options:
          headers: _.object ([header.name, header.default] for header in action.headers)

    actions
