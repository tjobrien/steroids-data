{partialRight, merge, defaults} = require 'lodash'
ajax = require '../ajax'
Promise = require 'bluebird'
{Success, Failure} = require 'data.validation'

# Validation a -> Promise a
validationToPromise = (validation) ->
  validation.fold(
    (errors) -> Promise.reject new Error JSON.stringify(errors)
    (value) -> Promise.resolve value
  )

# (a -> Validation b) -> (a -> Promise b)
validatorToPromised = (validator) -> (args...) ->
  validator(args...).fold(
    (errors) -> Promise.reject new Error JSON.stringify(errors)
    (value) -> Promise.resolve value
  )

deepDefaults = partialRight merge, defaults

validatorToResponseValidator = (validator) -> (response) ->
  if response.body
    validator response.body
  else if response.text
    validator response.text
  else
    Failure ["Empty response"]

responseValidator = (responseDataValidator) ->
  validateResponse = validatorToResponseValidator responseDataValidator
  (response) ->
    if response.error
      Failure [response.error]
    else
      validateResponse response

rest =
  # path: (args...) -> url
  # receive: (response) -> Validation data
  # options: {}
  getter: ({path, receive, options}) -> (args...) ->
    url = path args...

    ajax
      .request('get', url, options || {})
      .then(validatorToPromised receive)

  # path: (data) -> url
  # through: Project data
  # expect: (data) -> Validation data
  # options: {}
  poster: ({path, through, expect, options}) -> (data) ->
    url = path data
    validationToPromise(through.to data)
      .then((data) ->
        ajax.post(url, defaults({data}, options || {}))
      )
      .then(through.from)
      .then(validationToPromise)
      .then(expect)
      .then(validationToPromise)

  # path: (args...) -> url
  # options: {}
  deleter: ({path, options}) -> (args...) ->
    url = path args...
    ajax
      .del(url, options || {})

  # path: (args..., data) -> url
  # through: Project data
  # expect: (data) -> Validation data
  # options: {}
  putter: ({path, through, expect, options}) -> (args..., data) ->
    url = path args...
    validationToPromise(through.to data)
      .then((data) ->
        ajax.put(url, defaults({data}, options || {}))
      )
      .then(through.from)
      .then(validationToPromise)
      .then(expect)
      .then(validationToPromise)

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