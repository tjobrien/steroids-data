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
    return

  
  # Fetch all objects from the local JSON (see app/models/task.js)
  TaskResource.findAll().then (tasks) ->
    $scope.$apply ->
      $scope.tasks = tasks
  
  # -- Native navigation
  steroids.view.navigationBar.show "Task index"
  return


# Show: http://localhost/views/task/show.html?id=<id>
taskApp.controller "ShowCtrl", ($scope, $filter, TaskResource) ->
  
  # Fetch all objects from the local JSON (see app/models/task.js)
  TaskResource.findAll().then (tasks) ->
    
    # Then select the one based on the view's id query parameter
    $scope.task = $filter("filter")(tasks,
      task_id: steroids.view.params["id"]
    )[0]
    return

  
  # -- Native navigation
  steroids.view.navigationBar.show "Task: " + steroids.view.params.id
  return
