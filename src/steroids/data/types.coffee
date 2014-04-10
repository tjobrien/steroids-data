{Success, Failure} = require 'data.validation'

# List [String, Validation] -> Validation Object
objectSequence = (nameValidationPairs) ->
  failures = []
  result = for [name, validation] in nameValidationPairs
    validation.fold(
      (failure) -> failures.push failure; [name, null]
      (success) -> [name, success]
    )

  if failures.length > 0
    Failure failures
  else
    Success pairsToObject result

# List [String, Any] -> Object
pairsToObject = (pairs) ->
  result = {}
  for [key, value] in pairs
    result[key] = value
  result

# List Validation -> Validation List
listSequence = (list) ->
  failures = []
  result = for validation in list
    validation.fold(
      (failure) -> failures.push failure; null
      (success) -> success
    )
  if failures.length > 0
    Failure failures
  else
    Success result

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

  Object: (memberTypes) ->
    propertyProjections = do ->
      result = {}
      for name, type of memberTypes
        result[name] = types.Property(name, type)
      result

    (object) ->
      objectSequence ([name, projectPropertyFrom(object)] for name, projectPropertyFrom of propertyProjections)

  List: (type) -> (list) ->
    listSequence (type(value) for value in list)
      


