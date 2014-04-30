require('chai').use(require 'chai-as-promised')

BuiltioResource = require '../../../src/steroids/data/resources/builtio'
types = require '../../../src/steroids/data/types'

Task = do ({Object, String, Boolean, Optional} = types) ->
  Object
    description: String
    completed: Boolean
    uid: Optional String

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
    createSampleTask = TaskResource.create(description: 'do nothing', completed: false)
    it "can create a new task", ->
      createSampleTask.then (task) ->
        task.description.should.equal 'do nothing'

    it "can update a newly created task", ->
      createSampleTask.then (task) ->
        task.completed.should.be.false
        TaskResource.update(task.uid, completed: true).then (updatedTask) ->
          updatedTask.completed.should.be.true

    it "can find all tasks", ->
      createSampleTask.then (task) ->
        TaskResource.findAll().then (tasks) ->
          tasks.should.not.be.empty

    foundTask = createSampleTask.then (task) ->
      TaskResource.find(task.uid)

    it "can find a single task", ->
      createSampleTask.then (createdTask) ->
        foundTask.then (gotTask) ->
          createdTask.should.eql gotTask

    describe "A single task received from TaskResource", ->
      it "has a description", ->
        foundTask.then (task) ->
          task.description.should.be.a 'string'

      it "has a completion status", ->
        foundTask.then (task) ->
          task.completed.should.be.a 'boolean'

    it "can delete a newly created task", ->
      createSampleTask.then (task) ->
        TaskResource.del(task.uid).then (done) ->
          done.should.be.defined
          
          TaskResource.find(task.uid).should.be.rejected
