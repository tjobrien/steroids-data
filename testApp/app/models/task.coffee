
Task = steroids.data.schema.json {
  type: "object"
  properties:
    description:
      type: "string"
      required: true
    completed:
      type: "boolean"
    uid:
      type: "string"
}

TaskResource = steroids.data.resources.builtio(
  applicationApiKey: 'blt349bf00642a3a1b7'
  applicationUid: 'steroids-data-test-app'
  name: 'task'
  schema: Task
)

angular
  .module('TaskModel', [])
  .constant('TaskResource', TaskResource)