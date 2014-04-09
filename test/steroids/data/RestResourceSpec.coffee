require('chai').should()

TaskResource =
  findAll: ->

describe "Accessing data from a RESTful backend", ->
  it "can be done using a user-defined resource", ->
    TaskResource.findAll.should.be.defined

