ajax = require '../ajax'
Promise = require 'bluebird'

module.exports =
  getter: ({from, to}) -> (args...) ->
    url = from args...
    ajax
      .get(url)
      .then(to)
      .then (validation) ->
        validation.fold(
          (errors) -> Promise.reject new Error errors
          (value) -> Promise.resolve value
        )