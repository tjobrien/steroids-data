ajax = require '../ajax'
Promise = require 'bluebird'

# Validation a -> Promise a
validationToPromise = (validation) ->
  validation.fold(
    (errors) -> Promise.reject new Error errors
    (value) -> Promise.resolve value
  )

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
