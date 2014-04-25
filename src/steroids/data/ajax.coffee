superagent = require 'superagent'
Promise = require 'bluebird'

# requestBuilder -> Promise res
requestBuilderToResponsePromise = (requestBuilder) ->
  new Promise (resolve, reject) ->
    requestBuilder.end (err, res) ->
      if err
        reject err
      else
        resolve res

responsetoResponseBody = (response) ->
  if response.error
    throw new Error response.error
  else if response.body
    response.body
  else if response.text
    response.text
  else
    throw new Error "Empty response"

request = (method, path, options = {}) ->
  requestBuilderToResponsePromise do ->

    requestBuilder = superagent[method](
      if options.baseUrl?
        [options.baseUrl, path].join '/'
      else
        path
    )

    if options.headers
      for header, value of options.headers || {}
        requestBuilder.set header, value

    if options.data
      requestBuilder.send options.data

    if options.type?
      requestBuilder.type options.type

    if options.accept?
      requestBuilder.accept options.accept

    if options.buffer
      requestBuilder.buffer()

    requestBuilder

requestDataByMethod = (method) -> (path, options = {}) ->
  request(method, path, options)
    .then(responsetoResponseBody)

module.exports = ajax =
  request: request
  get: requestDataByMethod 'get'
  post: requestDataByMethod 'post'
  del: requestDataByMethod 'del'
  put: requestDataByMethod 'put'
