require('chai').should()

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

    newTask = TaskResource.create(object: { description: 'do nothing', completed: false })
    it "can create a new task", ->
      newTask.then (task) ->
        task.description.should.equal 'do nothing'

    it "can delete a newly created task", ->
      newTask.then (task) ->
        TaskResource.del(task.uid).then (done) ->
          done.should.be.defined
