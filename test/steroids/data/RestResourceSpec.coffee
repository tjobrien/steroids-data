require('chai').should()

request = require 'superagent'
Promise = require 'bluebird'

TaskResource =
  findAll: -> new Promise (resolve, reject) ->
    request
      .get('http://localhost:9001/data/task.json')
      .end (err, res) ->
        if err
          reject err
        else if res.error
          reject res.error
        else
          resolve res.body


describe "Accessing data from a static REST backend", ->
  it "can be done using a user-defined resource", ->
    TaskResource.should.be.defined

  describe "A user-defined TaskResource", ->
    it "can find all tasks", ->
      TaskResource.findAll().then (tasks) ->
        tasks.should.not.be.empty

    it "can find a single task", ->
      TaskResource.find('bltc95644acbfe2ca34').then (task) ->
        task.should.not.be.empty
