{partialRight, merge, defaults} = require 'lodash'
ajax = require '../ajax'
Promise = require 'bluebird'

# Validation a -> Promise a
validationToPromise = (validation) ->
  validation.fold(
    (errors) -> Promise.reject new Error JSON.stringify(errors)
    (value) -> Promise.resolve value
  )

merge = (objects...) ->
  _.merge {}, objects...

rest =
  # path: (args...) -> url
  # through: Project data
  # expect: (data) -> Validation data
  # options: {}
  getter: ({path, through, expect, options}) -> (args...) ->
    url = path args...
    ajax
      .get(url, options || {})
      .then(through.from)
      .then(validationToPromise)
      .then(expect)
      .then(validationToPromise)

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
    resourceBuilder merge resourceDescription, { options }

  get: withDefaultOptions rest.getter
  post: withDefaultOptions rest.poster
  delete: withDefaultOptions rest.deleter
  put: withDefaultOptions rest.putter

module.exports = restful = (options, apiDescriptor) ->
  apiDescriptor restMethodBuilder options