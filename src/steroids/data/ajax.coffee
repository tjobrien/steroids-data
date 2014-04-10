superagent = require 'superagent'
Promise = require 'bluebird'

# requestBuilder -> Promise data
requestToPromise = (requestBuilder) ->
  new Promise (resolve, reject) ->
    requestBuilder.end (err, res) ->
      if err
        reject err
      else if res.error
        reject res.error
      else
        resolve res.body

request = (method) -> (path, options = {}) ->
  requestToPromise do ->
    request = superagent[method](path)

    if options.headers
      for header, value of options.headers || {}
        request.set header, value

    request

module.exports = ajax =
  get: request 'get'
