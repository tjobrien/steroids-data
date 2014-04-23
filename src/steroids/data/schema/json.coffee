{Success, Failure} = require 'data.validation'
types = require '../types'

# (schema) -> (value) -> Validation value
module.exports = (schema = {}) ->
  switch schema?.type
    when "string" then types.String
    when "number" then types.Number
    when "boolean" then types.Boolean
    when "object" then types.Map types.Any
    when "array" then types.List types.Any
    else types.Any