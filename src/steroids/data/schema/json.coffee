{Success, Failure} = require 'data.validation'
types = require '../types'

# (schema) -> (value) -> Validation value
module.exports = (schema = {}) ->
  switch schema?.type
    when "string" then types.String
    when "number" then types.Number
    when "boolean" then types.Boolean
    else types.Any