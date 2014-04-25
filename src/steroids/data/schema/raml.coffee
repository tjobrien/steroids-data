ramlParser = require 'raml-parser'

module.exports =
  fromFile: (url) ->
    ramlParser.loadFile url
