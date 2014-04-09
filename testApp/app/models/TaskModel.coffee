angular
  .module('TaskModel')
  .service('TaskResource', ($q) ->
    findAll: -> $q.when([])
  )