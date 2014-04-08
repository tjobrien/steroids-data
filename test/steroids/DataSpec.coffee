require('chai').should()

Data = require '../../src/steroids/data'

describe "Steroids Data", ->
  it "is defined", ->
    Data.should.be.defined