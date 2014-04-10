rest = require './rest'

api = (baseUrl) ->
  get: ({from, to}) ->
    rest.getter
      from: (args...) -> [baseUrl, from(args...)].join '/'
      to: to

module.exports = restful = (baseUrl, apiDescriptor) ->
  apiDescriptor api baseUrl