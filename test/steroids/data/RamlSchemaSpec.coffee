require('chai').use(require 'chai-as-promised')

ramlSchema = require '../../../src/steroids/data/schema/raml'
schemaFileUrl = 'http://localhost:9001/data/car/resource.raml'

describe "steroids.data.schema.raml", ->
  it "should have a function for reading a schema from a file", ->
    ramlSchema.fromFile.should.be.a 'function'

  describe "reading a raml schema file", ->
    {fromFile} = ramlSchema
    serviceSchema = fromFile(schemaFileUrl)

    it "should accept a url and return a schema", ->
      serviceSchema.should.eventually.not.be.empty

    describe "resulting service schema", ->
      it "should have a title", ->
        serviceSchema.should.eventually.have.property('title')

      it "should have resources", ->
        serviceSchema.should.eventually.have.property('resources')

      forEachResource = (assert) ->
        serviceSchema.should.eventually.satisfy (schema) ->
          for resource in schema.resources
            assert(resource)

      describe "each resource", ->
        it "should have a relative path", ->
          forEachResource (resource) ->
            resource.relativeUri.should.be.a 'string'

        it "should have methods", ->
          forEachResource (resource) ->
            resource.methods.should.be.an.array

        forEachMethod = (assert) ->
          forEachResource (resource) ->
            for method in resource.methods
              assert method

        describe "each method", ->
          it "should have a description", ->
            forEachMethod (method) ->
              method.should.have.property 'description'


  it "should have a function for converting a schema to a resource", ->
    ramlSchema.toResource.should.be.a 'function'

  xdescribe "converting a schema to a resource", ->
    schema = ramlSchema.fromFile schemaFileUrl
    {toResource} = ramlSchema

    it "should accept a schema and return a resource object", ->
      toResource(schema).should.be.an.object

    describe "the resulting resource object", ->
      resource = toResource(schema)

      it "should have a method for each path in the schema", ->
        (methodName for methodName, method of resource when method instanceof Function)
          .should.have.length.of 2
