angular
  .module('TaskModel')
  .service('TaskResource', ($http) ->
    findAll: ->
      $http
        .get('http://localhost/data/task.json')
        .then(JSON.parse)
        .then (root) ->
          root.objects || []
  )