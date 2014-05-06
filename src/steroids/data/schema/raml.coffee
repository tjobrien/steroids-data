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

  resource: (name) ->
    for resource in @resources
      if resource.metadata.name is name
        return resource

    throw new Error "Resource '#{name}' not found in schema"

  class ResourceSchema
    constructor: ({
      @relativeUri
      methods
      resources
      description
    }) ->
      @actions = (new ActionSchema method for method in methods || [])
      @resources = (new ResourceSchema resource for resource in resources || [])
      @metadata = new ResourceMetadataSchema JSON.parse (description || '{}')

    # Flattens nested resources to a map from action names to actions
    actionsByName: do ->
      resourceActionsAndUriByName = (relativeUri, resourceActions) ->
        actions = {}

        for action in resourceActions
          actions[action.name()] = {
            relativeUri: relativeUri
            action: action
          }

        actions

      scanResourcesForActions = (relativeUri, resources) ->
        actions = {}

        for resource in resources
          uri = ([relativeUri, resource.relativeUri].join '')

          _.merge(
            actions
            resourceActionsAndUriByName(uri, resource.actions)
            scanResourcesForActions(uri, resource.resources)
          )

        actions

      ->
        scanResourcesForActions '', [this]

    class ResourceMetadataSchema
      constructor: ({
        resourceName
      }) ->
        @name = resourceName

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
        @metadata = new ActionMetadataSchema JSON.parse (description || '{}')

      name: ->
        @metadata.name || ''

      headerDefaults: ->
        defaults = {}
        for header in @headers when header.default?
          defaults[header.name] = header.default
        defaults

      class ActionMetadataSchema
        constructor: ({
          action
          @rootKey
        }) ->
          @name = action

      class ResponseSchema
        constructor: (
          @code
          response
        ) ->
          @body = response.body ? {}
          @metadata = new ResponseMetadataSchema JSON.parse response.description || '{}'

        class ResponseMetadataSchema
          constructor: ({
            @rootKey
          }) ->

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
