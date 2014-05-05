require('chai').use(require 'chai-as-promised')

{fromObject} = require '../../../src/steroids/data/schema/raml'
ramlResource = require '../../../src/steroids/data/resources/raml'

TaskResource = ramlResource('task') fromObject
  title: 'Tasks'
  baseUri: 'http://localhost:9001/data/task'
  resources: [
    {
      description: JSON.stringify {
        resourceName: "task"
      }
      relativeUri: '/objects'
      resources: [
        {
          relativeUri: '.json'
          methods: [
            {
              method: 'get'
              description: JSON.stringify {
                action: "findAll"
              }
              body: {}
              responses:
                200:
                  description: JSON.stringify {
                    rootKey: "objects"
                  }
                  body:
                    "application/json": {}
              headers:
                application_uid:
                  default: 'steroids-data-test-app'
                application_api_key:
                  default: 'blt349bf00642a3a1b7'
            }
          ]
        }
        {
          relativeUri: '/{id}.json'
          methods: [
            {
              method: 'get'
              description: JSON.stringify {
                action: "find"
              }
              body: {}
              responses:
                200:
                  description: JSON.stringify {
                    rootKey: "object"
                  }
                  body:
                    "application/json": {}
              headers: {}
            }
          ]
        }
      ]
    }
  ]


describe "Accessing data from a static REST backend with steroids.data.resources.raml", ->
  it "can be done using a user-defined resource", ->
    TaskResource.should.be.defined

  describe "A user-defined TaskResource", ->
    it "can find all tasks", ->
      TaskResource.findAll().should.eventually.not.be.empty

    sampleTask = null

    it "can find a single task", ->
      sampleTask = TaskResource.find('bltc95644acbfe2ca34')
      sampleTask.should.eventually.be.an.object

    xdescribe "A single task received from TaskResource", ->
      it "has a description", ->
        sampleTask.should.eventually.have.property 'description'

