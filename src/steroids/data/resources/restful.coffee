rest = require './rest'

api = (options) ->
  baseUrl = options.baseUrl || ''
  headers = options.headers || {}

  get: ({from, expect}) ->
    rest.getter
      from: (args...) -> [baseUrl, from(args...)].join '/'
      expect: expect

module.exports = restful = (baseUrl, apiDescriptor) ->
  apiDescriptor api baseUrl