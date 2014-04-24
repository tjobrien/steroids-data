{Success, Failure} = require 'data.validation'
types = require '../types'

arrayTypeFromItemSchema = (itemSchema) ->
  types.List (typeFromJsonSchema itemSchema)

# (schema) -> (value) -> Validation value
typeFromJsonSchema = (schema = {}) ->
  switch schema?.type
    when "string" then types.String
    when "number" then types.Number
    when "boolean" then types.Boolean
    when "object" then types.Map types.Any
    when "array" then arrayTypeFromItemSchema schema?.items || {}
    else types.Any

module.exports = typeFromJsonSchema