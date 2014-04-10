require('chai').should()

types = require '../../../src/steroids/data/types'

describe "Typing data with steroids.data.types", ->
  it "Should have a String type", ->
    types.String.should.be.defined