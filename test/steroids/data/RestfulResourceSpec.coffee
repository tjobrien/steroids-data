require('chai').should()

restful = require '../../../src/steroids/data/resources/restful'
types = require '../../../src/steroids/data/types'

Task = types.Object
  description: types.String

TaskResource = restful {
  baseUrl: 'http://localhost:9001/data/task'
}, (api) ->

  findAll: api.get
    from: -> 'objects.json'
    expect: types.Property 'objects', types.List Task

  find: api.get
    from: (id) -> "objects/#{id}.json"
    expect: types.Property 'object', Task


describe "Accessing data from a static REST backend", ->
  it "can be done using a user-defined resource", ->
    TaskResource.should.be.defined

  describe "A user-defined TaskResource", ->
    it "can find all tasks", ->
      TaskResource.findAll().then (tasks) ->
        tasks.should.not.be.empty

    sampleTask = TaskResource.find('bltc95644acbfe2ca34')

    it "can find a single task", ->
      sampleTask.then (task) ->
        task.should.be.an 'object'

    describe "A single task received from TaskResource", ->
      it "has a description", ->
        sampleTask.then (task) ->
          task.description.should.be.a 'string'
