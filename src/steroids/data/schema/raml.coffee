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
