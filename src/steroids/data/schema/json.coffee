{mapValues, contains} = require 'lodash'
{Success, Failure} = require 'data.validation'
types = require '../types'
ajax = require '../ajax'

arrayTypeFromItemSchema = (itemSchema) ->
  types.List (typeFromJsonSchema itemSchema)

objectTypeFromPropertySchema = (propertiesToSchemas, requiredProperties) ->
  if !propertiesToSchemas?
    types.Map types.Any
  else
    types.Object (mapValues propertiesToSchemas, (propertySchema, propertyName) ->
      propertyType = typeFromJsonSchema propertySchema
      if propertySchema?.required or (contains requiredProperties, propertyName)
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
    when "object" then objectTypeFromPropertySchema (schema.properties || null), (schema.required || [])
    when "array" then arrayTypeFromItemSchema schema.items || {}
    else types.Any

module.exports =
  fromFile: (url) -> ajax.get url
  toType: typeFromJsonSchema