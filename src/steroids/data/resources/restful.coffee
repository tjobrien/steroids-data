rest = require './rest'

api = (options) ->
  get: ({from, expect}) ->
    rest.getter {
      from
      expect
      options
    }

  post: ({to, expect}) ->
    rest.poster {
      to
      expect
      options
    }

  del: ({at}) ->
    rest.deleter {
      at
      options
    }

module.exports = restful = (baseUrl, apiDescriptor) ->
  apiDescriptor api baseUrl