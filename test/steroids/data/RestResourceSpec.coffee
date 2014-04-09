require('chai').should()

request = require 'superagent'
Promise = require 'bluebird'

ajax =
  get: (path) ->
    new Promise (resolve, reject) ->
      request
        .get(path)
        .end (err, res) ->
          if err
            reject err
          else if res.error
            reject res.error
          else
            resolve res.body

TaskResource =
  findAll: ->
    ajax
      .get('http://localhost:9001/data/task.json')
      .then (data) ->
        data.objects || []

  find: (id) ->
    TaskResource.findAll().then (tasks) ->
      for task in tasks when task.uid is id
        return task
      Promise.reject new Error "#{id} not found"


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

