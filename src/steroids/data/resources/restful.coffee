rest = require './rest'

api = (options) ->
  get: ({from, through, expect}) ->
    rest.getter {
      from
      through
      expect
      options
    }

  post: ({to, through, expect}) ->
    rest.poster {
      to
      through
      expect
      options
    }

  del: ({at}) ->
    rest.deleter {
      at
      options
    }

  put: ({at, through, expect}) ->
    rest.putter {
      at
      through
      expect
      options
    }

module.exports = restful = (options, apiDescriptor) ->
  apiDescriptor api options