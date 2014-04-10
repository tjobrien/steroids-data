{Success, Failure} = require 'data.validation'

module.exports =
  String: (input) ->
    if typeof input is 'string'
      Success input
    else
      Failure ['Input was not of type string']

  Property: (name) -> (object) ->
    if object?[name]?
      Success object[name]
    else
      Failure ["Input did not have property '#{name}'"]
