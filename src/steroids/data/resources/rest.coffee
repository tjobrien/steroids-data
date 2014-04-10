ajax = require '../ajax'
Promise = require 'bluebird'

# Validation a -> Promise a
validationToPromise = (validation) ->
  validation.fold(
    (errors) -> Promise.reject new Error errors
    (value) -> Promise.resolve value
  )

module.exports =
  getter: ({from, expect}) -> (args...) ->
    url = from args...
    ajax
      .get(url)
      .then(expect)
      .then(validationToPromise)