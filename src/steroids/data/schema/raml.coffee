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
    resources
  }) ->
    @resources = (new ResourceSchema resource for resource in resources)

  class ResourceSchema
    constructor: ({
      @relativeUri
      methods
    }) ->
      @methods = (new MethodSchema method for method in methods)

    class MethodSchema
      constructor: ({
        @description,
        method
      }) ->
        @type = method

module.exports =
  fromFile: (url) ->
    Promise.cast(ramlParser.loadFile url, { reader: new FileReader })
      .then((service) -> new ServiceSchema service)

  toResource: (schema) -> {}
