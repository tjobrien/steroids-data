{mapValues} = require 'lodash'
{Success, Failure} = require 'data.validation'
types = require '../types'

arrayTypeFromItemSchema = (itemSchema) ->
  types.List (typeFromJsonSchema itemSchema)

objectTypeFromPropertySchema = (propertiesToSchemas) ->
  if !propertiesToSchemas?
    types.Map types.Any
  else
    types.Object (mapValues propertiesToSchemas, (propertySchema) ->
      propertyType = typeFromJsonSchema propertySchema
      if propertySchema?.required
        propertyType
      else
        types.Optional propertyType
    )

# (schema) -> (value) -> Validation value
typeFromJsonSchema = (schema = {}) ->
  switch schema?.type
    when "string" then types.String
    when "number" then types.Number
    when "boolean" then types.Boolean
    when "object" then objectTypeFromPropertySchema (schema.properties || null)
    when "array" then arrayTypeFromItemSchema schema.items || {}
    else types.Any

module.exports = typeFromJsonSchema