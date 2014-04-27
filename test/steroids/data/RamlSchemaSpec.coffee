require('chai').use(require 'chai-as-promised')

ramlSchema = require '../../../src/steroids/data/schema/raml'
schemaFileUrl = 'http://localhost:9001/data/car/resource.raml'

describe "steroids.data.schema.raml", ->
  it "should have a function for reading a schema from a file", ->
    ramlSchema.fromFile.should.be.a 'function'

  describe "reading a raml schema file", ->
    {fromFile} = ramlSchema

    it "should accept a url and return a schema", ->
      fromFile(schemaFileUrl).should.eventually.not.be.empty

  it "should have a function for converting a schema to a resource", ->
    ramlSchema.toResource.should.be.a 'function'

  describe "converting a schema to a resource", ->
    schema = ramlSchema.fromFile schemaFileUrl
    {toResource} = ramlSchema

    it "should accept a schema and return a resource object", ->
      toResource(schema).should.be.an.object