restful = require './restful'
types = require '../types'

module.exports = builtio = ({applicationApiKey, applicationUid, name, schema}) ->
  restful {
    baseUrl: "http://localhost:9001/data/#{name}"
  }, (api) ->

    findAll: api.get
      from: -> 'objects.json'
      expect: types.Property 'objects', types.List schema

    find: api.get
      from: (id) -> "objects/#{id}.json"
      expect: types.Property 'object', schema