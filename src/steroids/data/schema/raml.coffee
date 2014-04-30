_ = require 'lodash'
Promise = require 'bluebird'
ajax = require '../ajax'
ramlParser = require 'raml-parser'

class FileReader extends ramlParser.FileReader
  fetchFileAsync: (url) ->
    ajax
      .request('get', url, buffer: true)
      .then((response) -> response.text)

class ServiceSchema
  constructor: ({
    @title
    @baseUri
    resources
  }) ->
    @resources = (new ResourceSchema resource for resource in resources)

  # Flattens nested resources to a map from relative uris to actions
  actions: do ->
    resourceToActions = (relativeUri, resource) ->
      actions = {}

      for action in resource.actions
        actionUri = [relativeUri, resource.relativeUri].join ''
        actions[actionUri] = action

      actions

    scanResourcesForActions = (relativeUri, resources) ->
      actions = {}

      for resource in resources
        _.merge(
          actions
          resourceToActions(relativeUri, resource)
          scanResourcesForActions(resource.relativeUri, resource.resources)
        )

      actions

    ->
      scanResourcesForActions '', @resources

  class ResourceSchema
    constructor: ({
      @relativeUri
      methods
      resources
    }) ->
      @actions = (new ActionSchema method for method in methods)
      @resources = (new ResourceSchema resource for resource in resources || [])

    class ActionSchema
      constructor: ({
        @method
        @body
        headers
        responses
        description
      }) ->
        @responses = (new ResponseSchema code, (response || {}) for code, response of responses)
        @headers = (new HeaderSchema name, (header || {}) for name, header of headers)
        @metadata = new DescriptionSchema JSON.parse description

      class DescriptionSchema
        constructor: ({
          action
        }) ->
          @name = action

      class ResponseSchema
        constructor: (
          @code
          response
        ) ->
          @body = response.body ? {}

      class HeaderSchema
        constructor: (
          @name
          {
            @default
          }
        ) ->


module.exports =
  fromFile: (url) ->
    Promise
      .cast(ramlParser.loadFile url, { reader: new FileReader })
      .then(module.exports.fromObject)

  fromObject: (description) -> new ServiceSchema description

  toResource: (schema) -> {}
