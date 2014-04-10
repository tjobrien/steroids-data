{Success, Failure} = require 'data.validation'

module.exports = types =
  Any: Success

  String: (input) ->
    if typeof input is 'string'
      Success input
    else
      Failure ['Input was not of type string']

  Property: (name, type = types.Any) -> (object) ->
    if object?[name]?
      type object[name]
    else
      Failure ["Input did not have property '#{name}'"]
