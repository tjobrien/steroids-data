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

nativeTypeValidator = (type) -> (input) ->
  if typeof input is type
    Success input
  else
    Failure ["Input was not of type #{type}"]

module.exports = types =
  Any: (input) ->
    if input?
      Success input
    else
      Failure ["Input was undefined"]

  String: nativeTypeValidator 'string'

  Boolean: nativeTypeValidator 'boolean'

  Property: (name, type = types.Any) -> (object) ->
    (if object?[name]?
      type object[name]
    else
      type null
    ).leftMap (errors) ->
      result = {}
      result[name] = errors
      result

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
  
  Optional: (type) -> (input) ->
    if input?
      type(input)
    else
      Success null

  Projection:
    ToProperty: (name) -> (value) ->
      object = {}
      object[name] = value
      object

    FromProperty: (name) -> (object) ->
      if object?[name]?
        Success object[name]
      else
        Failure ["Object did not have property #{name}"]


