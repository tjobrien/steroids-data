require('chai').use(require 'chai-as-promised')

ramlSchema = require '../../../src/steroids/data/schema/raml'
schemaFileUrl = 'http://localhost:9001/data/car/resource.raml'

describe "steroids.data.schema.raml", ->

  it "should have a function for reading a schema from an object graph", ->
    ramlSchema.fromObject.should.be.a 'function'

  describe "reading a schema from an object graph", ->
    {fromObject} = ramlSchema
    serviceSchema = fromObject {
      title: 'Test Schema'
      baseUri: 'http://localhost'
      resources: [
        {
          relativeUri: '/objects'
          description: JSON.stringify {
            resourceName: "object"
          }
          methods: [
            {
              description: JSON.stringify {
                action: "findAll"
              }
              method: 'get'
              headers:
                foo:
                  default: 'bar'
              body: {}
              responses:
                200:
                  body: {}
            }
          ],
          resources: [
            relativeUri: '/nestedObject'
            methods: [
              {
                description: JSON.stringify {
                  action: "find"
                }
                method: 'get'
              }
            ]
          ]
        }
        {
          relativeUri: '/elsewhere'
          description: JSON.stringify {
            resourceName: "object"
          }
          methods: [
            {
              description: JSON.stringify {
                action: "somethingElse"
              }
            }
          ]
        }
      ]
    }

    it "should accept an object and return a schema", ->
      serviceSchema.should.not.be.empty

    describe "each schema", ->

      it "should allow finding a resource by a specific name", ->
        serviceSchema.resource('object').should.be.defined

      describe "each resource", ->
        it "should allow folding nested resources into a list of actions by their name", ->
          do (actions = serviceSchema.resource('object').actionsByName()) ->
            actions.should.have.property 'findAll'
            actions.should.have.property 'find'

        # NOTE: This will preclude support for structures where not everything
        # pertaining to one logical resource is under one resource-specific root
        it "will not contain actions defined in paths other than the first one", ->
          do (actions = serviceSchema.resource('object').actionsByName()) ->
            actions.should.not.have.property 'somethingElse'

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

      it "should have a baseUri", ->
        serviceSchema.should.eventually.have.property('baseUri')

      it "should have resources", ->
        serviceSchema.should.eventually.have.property('resources')

      forEachResource = (assert) ->
        serviceSchema.should.eventually.satisfy (schema) ->
          (for resource in schema.resources
            assert(resource)
          ).should.not.be.empty

      describe "each resource", ->
        it "should have a relative path", ->
          forEachResource (resource) ->
            resource.relativeUri.should.be.a 'string'

        it "should have actions", ->
          forEachResource (resource) ->
            resource.actions.should.be.an.array

        it "can have nested resources", ->
          forEachResource (resource) ->
            if resource.resources?
              resource.resources.should.be.an.array

        forEachAction = (assert) ->
          forEachResource (resource) ->
            (for action in resource.actions
              assert action
            ).should.not.be.empty

        forSomeAction = (where, assert) ->
          forEachResource (resource) ->
            (for action in resource.actions when where(action)
              assert action
            ).should.not.be.empty

        describe "each action", ->
          it "should have action name as metadata", ->
            forEachAction (action) ->
              action.should.have.property 'metadata'
              action.metadata.should.be.an.object
              action.metadata.name.should.be.a.string

          it "can have a rootKey as metadata", ->
            forSomeAction(
              (action) -> action.metadata.rootKey?
              (action) -> action.metadata.rootKey.should.be.a.string
            )

          it "should have a method", ->
            forEachAction (action) ->
              action.should.have.property 'method'
              action.method.should.be.a 'string'

          it "can have headers", ->
            forSomeAction(
              (action) -> action.headers?
              (action) -> action.headers.should.be.an.array
            )

          forEachHeader = (assert) ->
            forSomeAction(
              (action) -> action.headers?
              (action) ->
                (for header in action.headers
                  assert header
                ).should.not.be.empty
            )

          forSomeHeader = (where, assert) ->
            forSomeAction(
              (action) -> action.headers?
              (action) ->
                (for header in action.headers when where(header)
                  assert header
                ).should.not.be.empty
            )

          describe "each header", ->
            it "should have a name", ->
              forEachHeader (header) ->
                header.name.should.be.a.string

            it "can have a default value", ->
              forSomeHeader(
                (header) -> header.default?
                (header) -> header.default.should.be.a.string
              )

          it "can have a body", ->
            forSomeAction(
              (action) -> action.body?
              (action) -> action.body.should.be.an.object
            )

          it "should have responses", ->
            forEachAction (action) ->
              action.responses.should.be.an.object

          forEachResponse = (assert) ->
            forEachAction (action) ->
              (for response in action.responses
                assert response
              ).should.not.be.empty

          forSomeResponse = (where, assert) ->
            forEachAction (action) ->
              (for response in action.responses when where(response)
                assert response
              ).should.not.be.empty

          describe "each response", ->
            it "should have a code", ->
              forEachResponse (response) ->
                response.code.should.be.a.number

            it "can have a body", ->
              forSomeResponse(
                (response) -> response.body?
                (response) -> response.body.should.be.an.object
              )

            it "can have metadata with a rootKey", ->
              forSomeResponse(
                (response) -> response.metadata.rootKey?
                (response) -> response.metadata.rootKey.should.be.a.string
              )


  it "should have a function for converting a schema to a resource", ->
    ramlSchema.toResource.should.be.a 'function'

