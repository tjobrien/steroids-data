require('chai').use(require 'chai-as-promised')

restful = require '../../../src/steroids/data/resources/restful'
types = require '../../../src/steroids/data/types'

Task = types.Object
  description: types.String

TaskResource = restful {
  baseUrl: 'http://localhost:9001/data/task'
}, (api) ->

  findAll: api.get
    path: -> '/objects.json'
    receive: api.response types.Property 'objects', types.List Task

  find: api.get
    path: (id) -> "/objects/#{id}.json"
    receive: api.response types.Property 'object', Task


describe "Accessing data from a static REST backend with steroids.data.resources.restful", ->
  it "can be done using a user-defined resource", ->
    TaskResource.should.be.defined

  describe "A user-defined TaskResource", ->
    it "can find all tasks", ->
      TaskResource.findAll().should.eventually.be.an.array

    describe "a single task", ->
      sampleTask = TaskResource.find('bltc95644acbfe2ca34')

      it "is an object", ->
        sampleTask.should.eventually.be.an.object

      it "has a description", ->
        sampleTask.should.eventually.have.property 'description'
