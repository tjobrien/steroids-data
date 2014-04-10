rest = require './rest'

api = (baseUrl) ->
  get: ({from, expect}) ->
    rest.getter
      from: (args...) -> [baseUrl, from(args...)].join '/'
      expect: expect

module.exports = restful = (baseUrl, apiDescriptor) ->
  apiDescriptor api baseUrl