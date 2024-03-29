require('chai').should()

jsonSchema = require '../../../src/steroids/data/schema/json'

describe "steroids.data.schema.json", ->
  it "should have a function for reading a schema from a file", ->
    jsonSchema.fromFile.should.be.a 'function'

  describe "reading a json schema file", ->
    {fromFile} = jsonSchema
    schemaFileUrl = 'http://localhost:9001/data/car/resource/schema-cars.json'

    it "should accept a url and return a promise", ->
      fromFile(schemaFileUrl).then (schema) ->
        schema.should.be.an.object

  it "should have a function for converting a schema to a type", ->
    jsonSchema.toType.should.be.defined
    jsonSchema.toType.should.be.a 'function'

  describe "converting a schema to a type", ->
    {toType} = jsonSchema

    it "should accept a schema and return a validator", ->
      toType({}).should.be.a 'function'

    describe "an empty schema validation", ->
      it "should succeed with anything", ->
        anything = toType({})
        for value in ['anything', 123, {foo: "bar"}, ["qux"]]
          anything(value).isSuccess.should.be.true
          anything(value).get().should.deep.equal value

    describe "primitive type validation based on a schema", ->

      describe "a string type validation", ->
        string = toType type: "string"
        it "should succeed with a string", ->
          string("foo").isSuccess.should.be.true

        it "should fail with non-strings", ->
          for notAString in [123, {}, [], true]
            string(notAString).isFailure.should.be.true

      describe "a number type validation", ->
        number = toType type: "number"
        it "should succeed with a number", ->
          number(123).isSuccess.should.be.true
          number(1.23).isSuccess.should.be.true

        it "should fail with non-numbers", ->
          for notANumber in ["foo", {}, [], true]
            number(notANumber).isFailure.should.be.true

      describe "a boolean type validation", ->
        boolean = toType type: "boolean"
        it "should succeed with a boolean", ->
          boolean(false).isSuccess.should.be.true
          boolean(true).isSuccess.should.be.true

        it "should fail with non-booleans", ->
          for notABoolean in ["foo", 123, {}, []]
            boolean(notABoolean).isFailure.should.be.true

    describe "object type validation based on a schema", ->

      describe "with a plain object schema", ->
        object = toType type: "object"
        it "should succeed with an object", ->
          object({}).isSuccess.should.be.true
          object(foo: "bar").isSuccess.should.be.true

        it "should fail with non-objects", ->
          for notAnObject in ["foo", 123, [], false]
            object(notAnObject).isFailure.should.be.true

      describe "with typed properties", ->
        objectWithProperties = toType {
          type: "object"
          properties:
            numberProperty: { type: "number" }
            stringProperty: { type: "string" }
            booleanProperty: { type: "boolean" }
        }

        it "should succeed with an object that matches given properties", ->
          objectWithProperties(
            numberProperty: 123
            stringProperty: "anything"
            booleanProperty: true
          ).isSuccess.should.be.true

        it "should not fail with an object where something is missing", ->
          objectWithProperties(
            numberProperty: 123
          ).isSuccess.should.be.true

        it "should fail with an object where any property fails to typecheck", ->
          objectWithProperties(
            numberProperty: 123
            stringProperty: "anything"
            booleanProperty: 123
          ).isFailure.should.be.true

      describe "with required properties", ->
        objectWithRequiredProperties = toType {
          type: "object"
          properties:
            stringProperty:
              type: "string"
            requiredBooleanProperty:
              type: "boolean"
              required: true
            requiredNumberProperty:
              type: "number"
          required: ["requiredNumberProperty"]
        }

        it "should succeed with an object that has all required properties", ->
          objectWithRequiredProperties(
            requiredBooleanProperty: true
            requiredNumberProperty: 123
          ).isSuccess.should.be.true

        it "should fail an object that is missing a property required directly in the property definition", ->
          objectWithRequiredProperties(
            stringProperty: "anything"
            requiredNumberProperty: 123
          ).isFailure.should.be.true

        it "should fail an object that is missing a property required in the required property list", ->
          objectWithRequiredProperties(
            stringProperty: "anything"
            requiredBooleanProperty: true
          ).isFailure.should.be.true


    describe "array type validation based on a schema", ->

      describe "with a plain array schema", ->
        array = toType type: "array"

        it "should succeed with an array", ->
          array([]).isSuccess.should.be.true
          array(['bar']).isSuccess.should.be.true

        it "should fail with non-arrays", ->
          for notAnArray in ["foo", 123, {}, false]
            array(notAnArray).isFailure.should.be.true


      describe "with typed elements", ->
        stringArray = toType {
          type: "array"
          items:
            type: "string"
        }

        it "should succeed with an array of strings", ->
          for arrayOfStrings in [[], ['foo']]
            stringArray(arrayOfStrings).isSuccess.should.be.true

        it "should fail with an array where not all items match type", ->
          for notAnArrayOfStrings in [[123], ['foo', {}]]
            stringArray(notAnArrayOfStrings).isFailure.should.be.true

