require('chai').use(require 'chai-as-promised')

ramlSchema = require '../../../src/steroids/data/schema/raml'

describe "steroids.data.schema.raml", ->
  it "should have a function for reading a schema from a file", ->
    ramlSchema.fromFile.should.be.a 'function'

  describe "reading a raml schema file", ->
    {fromFile} = ramlSchema
    schemaFileUrl = 'http://localhost:9001/data/car/resource.raml'

    it "should accept a url and return a schema", ->
      fromFile(schemaFileUrl).should.eventually.not.be.empty
