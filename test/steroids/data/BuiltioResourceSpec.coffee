require('chai').should()

BuiltioResource = require '../../../src/steroids/data/resources/builtio'
types = require '../../../src/steroids/data/types'

Task = types.Object
  description: types.String
  completed: types.Boolean

TaskResource = BuiltioResource(
  applicationApiKey: 'blt349bf00642a3a1b7'
  applicationUid: 'steroids-data-test-app'
  name: 'task'
  schema: Task
)

describe "Accessing data from Built.io backend", ->
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

      it "has a completion status", ->
        sampleTask.then (task) ->
          task.completed.should.be.a 'boolean'

