
Task = do ({Object, String, Boolean, Optional} = steroids.data.types) ->
  Object
    description: String
    completed: Optional Boolean
    uid: Optional String

TaskResource = steroids.data.resources.builtio(
  applicationApiKey: 'blt349bf00642a3a1b7'
  applicationUid: 'steroids-data-test-app'
  name: 'task'
  schema: Task
)

angular
  .module('TaskModel', [])
  .constant('TaskResource', TaskResource)