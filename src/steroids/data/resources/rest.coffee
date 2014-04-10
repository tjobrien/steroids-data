ajax = require '../ajax'
Promise = require 'bluebird'

module.exports =
  getter: ({from, expect}) -> (args...) ->
    url = from args...
    ajax
      .get(url)
      .then(expect)
      .then (validation) ->
        validation.fold(
          (errors) -> Promise.reject new Error errors
          (value) -> Promise.resolve value
        )