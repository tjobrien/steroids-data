ajax = require '../ajax'
ramlParser = require 'raml-parser'

class FileReader extends ramlParser.FileReader
  fetchFileAsync: (url) ->
    ajax
      .request('get', url, buffer: true)
      .then((response) -> response.text)

module.exports =
  fromFile: (url) ->
    ramlParser.loadFile url, { reader: new FileReader }
  toResource: (schema) -> {}
