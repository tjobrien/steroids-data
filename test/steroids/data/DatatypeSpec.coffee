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
