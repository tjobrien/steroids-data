_ = require 'lodash'
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
  # from: (args...) -> url
  # through: Project data
  # expect: (data) -> Validation data
  # options: {}
  getter: ({from, through, expect, options}) -> (args...) ->
    url = from args...
    ajax
      .get(url, options || {})
      .then(through.from)
      .then(validationToPromise)
      .then(expect)
      .then(validationToPromise)

  # to: (data) -> url
  # through: Project data
  # expect: (data) -> Validation data
  # options: {}
  poster: ({to, through, expect, options}) -> (data) ->
    url = to data
    validationToPromise(through.to data)
      .then((data) ->
        ajax.post(url, merge(options || {}, {data}))
      )
      .then(through.from)
      .then(validationToPromise)
      .then(expect)
      .then(validationToPromise)

  # at: (args...) -> url
  # options: {}
  deleter: ({at, options}) -> (args...) ->
    url = at args...
    ajax
      .del(url, options || {})

  # at: (args..., data) -> url
  # through: Project data
  # expect: (data) -> Validation data
  # options: {}
  putter: ({at, through, expect, options}) -> (args..., data) ->
    url = at args...
    validationToPromise(through.to data)
      .then((data) ->
        ajax.put(url, merge(options || {}, {data}))
      )
      .then(through.from)
      .then(validationToPromise)
      .then(expect)
      .then(validationToPromise)

api = (options) ->
  withDefaultOptions = (resourceBuilder) -> (resourceDescription) ->
    resourceBuilder merge resourceDescription, { options }

  get: withDefaultOptions rest.getter
  post: withDefaultOptions rest.poster
  del: withDefaultOptions rest.deleter
  put: withDefaultOptions rest.putter

module.exports = restful = (options, apiDescriptor) ->
  apiDescriptor api options