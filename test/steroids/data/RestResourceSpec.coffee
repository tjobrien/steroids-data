require('chai').should()

ajax = require '../../../src/steroids/data/ajax'
restful = require '../../../src/steroids/data/resources/restful'
types = require '../../../src/steroids/data/types'

TaskResource = restful 'http://localhost:9001/data/task', (api) ->

  findAll: api.get
    from: -> 'objects.json'
    to: types.Property 'objects'

  find: api.get
    from: (id) -> "objects/#{id}.json"
    to: types.Property 'object'


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

