require('chai').should()

jsonSchema = require '../../../src/steroids/data/schema/json'

describe "Validating JSON against a JSON-Schema description", ->
  it "can be done with steroids.data.schema.json", ->
    jsonSchema.should.be.defined