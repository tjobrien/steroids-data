request = require 'superagent'
Promise = require 'bluebird'

module.exports = ajax =
  get: (path) ->
    new Promise (resolve, reject) ->
      request
        .get(path)
        .end (err, res) ->
          if err
            reject err
          else if res.error
            reject res.error
          else
            resolve res.body

