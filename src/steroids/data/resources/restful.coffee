rest = require './rest'

api = (options) ->
  get: ({from, expect}) ->
    rest.getter {
      from
      expect
      options
    }

module.exports = restful = (baseUrl, apiDescriptor) ->
  apiDescriptor api baseUrl