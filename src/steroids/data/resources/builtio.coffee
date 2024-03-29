restful = require './restful'
types = require '../types'

builtioResourceBaseUrl = (name) -> "https://api.built.io/v1/classes/#{name}"

module.exports = builtio = ({applicationApiKey, applicationUid, name, schema}) ->
  restful {
    baseUrl: builtioResourceBaseUrl name
    headers:
      application_api_key: applicationApiKey
      application_uid: applicationUid
  }, (rest) ->

    findAll: rest.get
      path: -> '/objects.json'
      receive: rest.response types.Property 'objects', types.List schema

    find: rest.get
      path: (id) -> "/objects/#{id}.json"
      receive: rest.response types.Property 'object', schema

    create: rest.post
      send: rest.request types.projections.Property 'object'
      path: -> "/objects"
      receive: rest.response types.Property 'object', schema

    del: rest.delete
      path: (id) -> "/objects/#{id}.json"

    update: rest.put
      send: rest.request types.projections.Property 'object'
      path: (id) -> "/objects/#{id}.json"
      receive: rest.response types.Property 'object', schema
