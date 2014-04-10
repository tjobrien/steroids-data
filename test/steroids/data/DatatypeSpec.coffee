require('chai').should()

types = require '../../../src/steroids/data/types'

describe "Typing data with steroids.data.types", ->
  it "Should have a String type", ->
    types.String.should.be.a 'function'

  describe 'String type', ->
    it 'Should pass a string', ->
      types.String('anything').isSuccess.should.be.true

    it 'Should not pass undefined', ->
      types.String(undefined).isFailure.should.be.true

    it 'Should allow extracting value', ->
      types.String('anything').get().should.equal 'anything'

  it "Should have a Property type", ->
    types.Property.should.be.a 'function'

  describe 'Property type', ->
    NameProperty = types.Property('name')

    it 'Should accept a property name and return a validator', ->
      NameProperty.should.be.a 'function'

    it 'Should pass an object with the property', ->
      NameProperty(name: 'anything').isSuccess.should.be.true

    it 'Should fail an object without the property', ->
      NameProperty({}).isFailure.should.be.true

    it 'Should fail undefined', ->
      NameProperty(undefined).isFailure.should.be.true

    it 'Optionally accepts a type for the property', ->
      StringNameProperty = types.Property('name', types.String)
      StringNameProperty(name: undefined).isFailure.should.be.true
      StringNameProperty(name: 'anything').isSuccess.should.be.true

  it "Should have an Object type", ->
    types.Object.should.be.a 'function'

  describe "Object type", ->
    TaskType = types.Object(description: types.String)

    it 'Should accept an object of types and return a validator', ->
      TaskType.should.be.a.function

    it 'Should pass an object whose properties pass validation', ->
      TaskType(description: 'anything').isSuccess.should.be.true
      TaskType(description: undefined).isFailure.should.be.true

  it "Should have a List type", ->
    types.List.should.be.a 'function'

  describe "List type", ->
    StringList = types.List(types.String)
    
    it 'Should accept a type and return a validator', ->
      StringList.should.be.a.function

    it 'Should pass a list whose items pass validation', ->
      StringList([]).isSuccess.should.be.true
      StringList(['anything']).isSuccess.should.be.true
      StringList([null]).isFailure.should.be.true

