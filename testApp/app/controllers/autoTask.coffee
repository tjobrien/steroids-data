autoTaskApp = angular.module("autoTaskApp", [
  "TaskModel"
  "hmTouchevents"
])

# Index: http://localhost/views/autoTask/index.html
autoTaskApp.controller "IndexCtrl", ($scope, AutoTaskResource) ->

  refreshTasks = ->
    AutoTaskResource.then (tasks) ->
      tasks.findAll().then ({objects}) ->
        $scope.$apply ->
          $scope.tasks = objects

  $scope.complete = (id) ->
    AutoTaskResource.then (tasks) ->
      tasks.update(id, object: { completed: true })
        .then refreshTasks

  $scope.undo = (id) ->
    AutoTaskResource.then (tasks) ->
      tasks.update(id, object: { completed: false })
        .then refreshTasks

  $scope.todo = ''

  $scope.create = (todo) ->
    $scope.todo = ''
    AutoTaskResource.then (tasks) ->
      tasks.create(object: { description: todo, completed: false })
        .then refreshTasks
  
  # -- Native navigation
  steroids.view.navigationBar.show "Task index"

  refreshTasks()
