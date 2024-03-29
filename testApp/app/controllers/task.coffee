taskApp = angular.module("taskApp", [
  "TaskModel"
  "hmTouchevents"
])

# Index: http://localhost/views/task/index.html
taskApp.controller "IndexCtrl", ($scope, TaskResource) ->
  
  # Helper function for opening new webviews
  $scope.open = (id) ->
    webView = new steroids.views.WebView("/views/task/show.html?id=" + id)
    steroids.layers.push webView

  refreshTasks = ->
    TaskResource.findAll().then (tasks) ->
      $scope.$apply ->
        $scope.tasks = tasks

  $scope.complete = (id) ->
    TaskResource
      .update(id, { completed: true })
      .then refreshTasks

  $scope.undo = (id) ->
    TaskResource
      .update(id, { completed: false })
      .then refreshTasks

  $scope.todo = ''

  $scope.create = (todo) ->
    $scope.todo = ''
    TaskResource
      .create({ description: todo, completed: false })
      .then refreshTasks
  
  # -- Native navigation
  steroids.view.navigationBar.show "Task index"

  refreshTasks()


# Show: http://localhost/views/task/show.html?id=<id>
taskApp.controller "ShowCtrl", ($scope, $filter, TaskResource) ->
  
  # Fetch all objects from the local JSON (see app/models/task.js)
  TaskResource.find(steroids.view.params["id"]).then (task) ->
    $scope.$apply ->
      $scope.task = task
  
  # -- Native navigation
  steroids.view.navigationBar.show "Task: " + steroids.view.params.id
