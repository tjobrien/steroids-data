require('chai').should()

ajax = require '../../../src/steroids/data/ajax'
rest = require '../../../src/steroids/data/resources/rest'
types = require '../../../src/steroids/data/types'

TaskResource =
  findAll: rest.getter 'http://localhost:9001/data/task/objects.json', types.Property 'objects'

  find: (id) ->
    ajax
      .get("http://localhost:9001/data/task/objects/#{id}.json")
      .then (data) ->
        data.object || {}


describe "Accessing data from a static REST backend", ->
  it "can be done using a user-defined resource", ->
    TaskResource.should.be.defined

  describe "A user-defined TaskResource", ->
    it "can find all tasks", ->
      TaskResource.findAll().then (tasks) ->
        tasks.should.not.be.empty

    it "can find a single task", ->
      TaskResource.find('bltc95644acbfe2ca34').then (task) ->
        task.should.be.an 'object'

    describe "A single task received from TaskResource", ->
      it "has a description", ->
        TaskResource.find('bltc95644acbfe2ca34').then (task) ->
          task.description.should.be.a 'string'

