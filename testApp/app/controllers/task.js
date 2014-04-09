var taskApp = angular.module('taskApp', ['TaskModel', 'hmTouchevents']);


// Index: http://localhost/views/task/index.html

taskApp.controller('IndexCtrl', function ($scope, TaskResource) {

  // Helper function for opening new webviews
  $scope.open = function(id) {
    webView = new steroids.views.WebView("/views/task/show.html?id="+id);
    steroids.layers.push(webView);
  };

  // Fetch all objects from the local JSON (see app/models/task.js)
  $scope.tasks = TaskResource.findAll();

  // -- Native navigation
  steroids.view.navigationBar.show("Task index");

});


// Show: http://localhost/views/task/show.html?id=<id>

taskApp.controller('ShowCtrl', function ($scope, $filter, TaskResource) {

  // Fetch all objects from the local JSON (see app/models/task.js)
  TaskResource.findAll().then( function(tasks) {
    // Then select the one based on the view's id query parameter
    $scope.task = $filter('filter')(tasks, {task_id: steroids.view.params['id']})[0];
  });

  // -- Native navigation
  steroids.view.navigationBar.show("Task: " + steroids.view.params.id );

});
