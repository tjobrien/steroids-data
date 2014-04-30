require('chai').should()

{fromObject} = require '../../../src/steroids/data/schema/raml'
ramlResource = require '../../../src/steroids/data/resources/raml'

TaskResource = ramlResource 'task', fromObject
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
      TaskResource.findAll().then (tasks) ->
        tasks.should.not.be.empty

    sampleTask = null

    it "can find a single task", ->
      sampleTask = TaskResource.find('bltc95644acbfe2ca34')
      sampleTask.then (task) ->
        task.should.be.an 'object'

    # TODO: Add rootKey discovery to dig response data from {object}
    xdescribe "A single task received from TaskResource", ->
      it "has a description", ->
        sampleTask.then (task) ->
          task.description.should.be.a 'string'

