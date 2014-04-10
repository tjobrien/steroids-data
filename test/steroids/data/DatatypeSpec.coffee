require('chai').should()

types = require '../../../src/steroids/data/types'

describe "Typing data with steroids.data.types", ->
  it "Should have a String type", ->
    types.String.should.be.a 'function'

  describe 'String type', ->
    it 'Should pass a string', ->
      types.String('anything').isSuccess.should.beTrue

    it 'Should not pass undefined', ->
      types.String(undefined).isFailure.should.beTrue

    it 'Should allow extracting value', ->
      types.String('anything').get().should.equal 'anything'