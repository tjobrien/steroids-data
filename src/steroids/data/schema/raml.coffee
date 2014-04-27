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
    @resources
  }) ->

module.exports =
  fromFile: (url) ->
    Promise.cast(ramlParser.loadFile url, { reader: new FileReader })
      .then((schema) -> new ServiceSchema schema)

  toResource: (schema) -> {}
