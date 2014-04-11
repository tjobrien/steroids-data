ajax = require '../ajax'
Promise = require 'bluebird'

# Validation a -> Promise a
validationToPromise = (validation) ->
  validation.fold(
    (errors) -> Promise.reject new Error JSON.stringify(errors)
    (value) -> Promise.resolve value
  )

merge = (objects...) ->
  result = {}
  for object in objects
    for key, value of object
      result[key] = value
  result

module.exports =
  # from: (args...) -> url
  # expect: (data) -> Validation data
  # options: {}
  getter: ({from, expect, options}) -> (args...) ->
    url = from args...
    ajax
      .get(url, options || {})
      .then(expect)
      .then(validationToPromise)

  # to: (data) -> url
  # expect: (data) -> Validation data
  # options: {}
  poster: ({to, expect, options}) -> (data) ->
    url = to data
    ajax
      .post(url, merge(options || {}, {data}))
      .then(expect)
      .then(validationToPromise)

  # at: (args...) -> url
  # options: {}
  deleter: ({at, options}) -> (args...) ->
    url = at args...
    ajax
      .del(url, options || {})

  # at: (args..., data) -> url
  # expect: (data) -> Validation data
  # options: {}
  putter: ({at, expect, options}) -> (args..., data) ->
    url = at args...
    ajax
      .put(url, merge(options || {}, {data}))
      .then(expect)
      .then(validationToPromise)

