autoTaskApp = angular.module("autoTaskApp", [
  "TaskModel"
  "hmTouchevents"
])

# Index: http://localhost/views/autoTask/index.html
autoTaskApp.controller "IndexCtrl", ($scope, AutoTaskResource) ->
  refreshTasks = ->
    AutoTaskResource.findAll().then (objects) ->
      $scope.$apply ->
        $scope.tasks = objects

  $scope.complete = (id) ->
    AutoTaskResource.update(id, { completed: true })
      .then refreshTasks

  $scope.undo = (id) ->
    AutoTaskResource.update(id, { completed: false })
      .then refreshTasks

  $scope.todo = ''

  $scope.create = (todo) ->
    $scope.todo = ''
    AutoTaskResource.create({ description: todo, completed: false })
      .then refreshTasks
  
  # -- Native navigation
  steroids.view.navigationBar.show "Task index"

  refreshTasks()
