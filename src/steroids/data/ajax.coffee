request = require 'superagent'
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

module.exports = ajax =
  get: (path) ->
    requestToPromise request.get path
