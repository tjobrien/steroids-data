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

  TaskResource.findAll().then (tasks) ->
    $scope.$apply ->
      $scope.tasks = tasks
  
  # -- Native navigation
  steroids.view.navigationBar.show "Task index"


# Show: http://localhost/views/task/show.html?id=<id>
taskApp.controller "ShowCtrl", ($scope, $filter, TaskResource) ->
  
  # Fetch all objects from the local JSON (see app/models/task.js)
  TaskResource.find(steroids.view.params["id"]).then (task) ->
    $scope.$apply ->
      $scope.task = task
  
  # -- Native navigation
  steroids.view.navigationBar.show "Task: " + steroids.view.params.id
