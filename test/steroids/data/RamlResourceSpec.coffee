require('chai').should()

{fromObject} = require '../../../src/steroids/data/schema/raml'
ramlResource = require '../../../src/steroids/data/resources/raml'

TaskResource = ramlResource fromObject
  title: 'Tasks'
  baseUri: 'http://localhost:9001/data/task'
  resources: [
    {
      relativeUri: '/objects.json'
      methods: [
        {
          method: 'get'
          description: 'findAll'
          body: {}
          headers: {}
        }
      ]
    }
    {
      relativeUri: 'objects/{id}.json'
      methods: [
        {
          method: 'get'
          description: 'find'
          body: {}
          headers: {}
        }
      ]
    }
  ]


describe "Accessing data from a static REST backend with steroids.data.resources.raml", ->
  it "can be done using a user-defined resource", ->
    TaskResource.should.be.defined

  describe "A user-defined TaskResource", ->
    it "can find all tasks", ->
      TaskResource.findAll().then (tasks) ->
        tasks.should.not.be.empty

    sampleTask = null

    it "can find a single task", ->
      sampleTask = TaskResource.find('bltc95644acbfe2ca34')
      sampleTask.then (task) ->
        task.should.be.an 'object'

    describe "A single task received from TaskResource", ->
      it "has a description", ->
        sampleTask.then (task) ->
          task.description.should.be.a 'string'

