require('chai').should()

jsonSchema = require '../../../src/steroids/data/schema/json'

describe "Validating JSON against a JSON-Schema description", ->
  it "can be done with steroids.data.schema.json", ->
    jsonSchema.should.be.defined
    jsonSchema.should.be.a 'function'

  describe "using steroids.data.schema.json", ->
    it "should accept a schema and return a validator", ->
      jsonSchema({}).should.be.a 'function'

    it "should validate an empty schema", ->
      anything = jsonSchema({})
      for value in ['anything', 123, {foo: "bar"}, ["qux"]]
        anything(value).isSuccess.should.be.true
        anything(value).get().should.deep.equal value

