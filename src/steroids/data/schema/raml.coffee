ajax = require '../ajax'

module.exports =
  fromFile: (url) -> ajax.get url, accept: 'raml'