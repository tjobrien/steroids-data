
assert = require 'assert-plus'
Promise = require 'bluebird'

{partialRight, merge, defaults} = require 'lodash'
{Success, Failure} = require 'data.validation'

ajax = require '../ajax'
types = require '../types'

# Validation a -> Promise a
validationToPromise = (validation) ->
  validation.fold(
    (errors) -> Promise.reject new Error JSON.stringify(errors)
    (value) -> Promise.resolve value
  )

# (a -> Validation b) -> (a -> Promise b)
validatorToPromised = (validator) ->
  (args...) ->
    validationToPromise validator(args...)

deepDefaults = partialRight merge, defaults

validatorToResponseValidator = (validator) ->
  if typeof validator is 'function'
    types.OneOf [
      types.Property 'body', validator
      types.Property 'text', validator
    ]
  else
    types.OneOf (
      for responseCode, responseBodyValidator of validator
        # NOTE: This checks for the contents but not response code
        # TODO: Check for response status
        validatorToResponseValidator responseBodyValidator
    )

responseValidator = (responseDataValidator) ->
  do (validateResponse = validatorToResponseValidator responseDataValidator) ->
    (response) ->
      if response.error
        Failure [response.error]
      else
        validateResponse response

rest =
  # path: (args...) -> url
  # receive: (response) -> Validation data
  # options: {}
  getter: ({path, receive, options}) ->
    assert.func path, 'path'
    assert.func receive, 'receive'
    assert.optionalObject options, 'options'

    (args...) ->
      url = path args...

      ajax
        .request('get', url, options || {})
        .then(validatorToPromised receive)

  # path: (data) -> url
  # through: Project data
  # receive: (response) -> Validation data
  # options: {}
  poster: ({path, through, receive, options}) ->
    assert.func path, 'path'
    assert.object through, 'through'
    assert.func receive, 'receive'
    assert.optionalObject options, 'options'

    doPostRequest = (data) ->
      url = path data
      ajax.request('post', url, defaults({data}, options || {}))

    (data) ->
      validationToPromise(through.to data)
        .then(doPostRequest)
        .then(validatorToPromised receive)

  # path: (args...) -> url
  # options: {}
  deleter: ({path, options}) -> (args...) ->
    url = path args...
    ajax
      .del(url, options || {})

  # path: (args..., data) -> url
  # through: Project data
  # receive: (response) -> Validation data
  # options: {}
  putter: ({path, through, receive, options}) ->
    assert.func path, 'path'
    assert.object through, 'through'
    assert.func receive, 'receive'
    assert.optionalObject options, 'options'

    doPutRequest = (args) ->
      url = path args...
      (data) ->
        ajax.request('put', url, defaults({data}, options || {}))

    (args..., data) ->
      validationToPromise(through.to data)
        .then(doPutRequest(args))
        .then(validatorToPromised receive)

restMethodBuilder = (options) ->
  withDefaultOptions = (resourceBuilder) -> (resourceDescription) ->
    resourceBuilder deepDefaults resourceDescription, { options }

  get: withDefaultOptions rest.getter
  post: withDefaultOptions rest.poster
  delete: withDefaultOptions rest.deleter
  put: withDefaultOptions rest.putter

  response: responseValidator

module.exports = restful = (options, apiDescriptor) ->
  apiDescriptor restMethodBuilder options