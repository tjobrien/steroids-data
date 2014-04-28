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
      path: -> 'objects.json'
      through: types.Project.Property 'objects'
      expect: types.List schema

    find: rest.get
      path: (id) -> "objects/#{id}.json"
      through: types.Project.Property 'object'
      expect: schema

    create: rest.post
      through: types.Project.Property 'object'
      path: -> "objects"
      expect: schema

    del: rest.delete
      path: (id) -> "objects/#{id}.json"

    update: rest.put
      through: types.Project.Property 'object'
      path: (id) -> "objects/#{id}.json"
      expect: schema