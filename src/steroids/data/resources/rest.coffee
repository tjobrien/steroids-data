ajax = require '../ajax'
Promise = require 'bluebird'

module.exports =
  getter: (url, type) -> ->
    ajax
      .get(url)
      .then (data) ->
        type(data).fold(
          (errors) -> Promise.reject new Error errors
          (value) -> Promise.resolve value
        )