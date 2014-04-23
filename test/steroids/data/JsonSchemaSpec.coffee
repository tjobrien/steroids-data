require('chai').should()

jsonSchema = require '../../../src/steroids/data/schema/json'

describe "steroids.data.schema.json", ->
  it "should be a function", ->
    jsonSchema.should.be.defined
    jsonSchema.should.be.a 'function'

  it "should accept a schema and return a validator", ->
    jsonSchema({}).should.be.a 'function'

  describe "validating with an empty schema", ->
    it "should succeed with anything", ->
      anything = jsonSchema({})
      for value in ['anything', 123, {foo: "bar"}, ["qux"]]
        anything(value).isSuccess.should.be.true
        anything(value).get().should.deep.equal value

  describe "validating with a string type", ->
    string = jsonSchema type: "string"
    it "should succeed with a string", ->
      string("foo").isSuccess.should.be.true

    it "should fail with non-strings", ->
      for notAString in [123, {}, [], true]
        string(notAString).isFailure.should.be.true

  describe "validating with a number type", ->
    number = jsonSchema type: "number"
    it "should succeed with a number", ->
      number(123).isSuccess.should.be.true
      number(1.23).isSuccess.should.be.true

    it "should fail with non-numbers", ->
      for notANumber in ["foo", {}, [], true]
        number(notANumber).isFailure.should.be.true

  describe "validating with a boolean type", ->
    boolean = jsonSchema type: "boolean"
    it "should succeed with a boolean", ->
      boolean(false).isSuccess.should.be.true
      boolean(true).isSuccess.should.be.true

    it "should fail with non-booleans", ->
      for notABoolean in ["foo", 123, {}, []]
        boolean(notABoolean).isFailure.should.be.true

