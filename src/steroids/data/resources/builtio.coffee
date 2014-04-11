restful = require './restful'
types = require '../types'

builtioResourceBaseUrl = (name) -> "https://api.built.io/v1/classes/#{name}"

module.exports = builtio = ({applicationApiKey, applicationUid, name, schema}) ->
  restful {
    baseUrl: builtioResourceBaseUrl name
    headers:
      application_api_key: applicationApiKey
      application_uid: applicationUid
  }, (api) ->

    findAll: api.get
      from: -> 'objects.json'
      expect: types.Property 'objects', types.List schema

    find: api.get
      from: (id) -> "objects/#{id}.json"
      expect: types.Property 'object', schema

    create: api.post
      to: -> "objects"
      expect: types.Property 'object', schema

    del: api.del
      at: (id) -> "objects/#{id}.json"

    update: api.put
      at: (id) -> "objects/#{id}.json"
      expect: types.Property 'object', schema