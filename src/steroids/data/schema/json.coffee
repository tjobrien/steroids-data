{Success, Failure} = require 'data.validation'
types = require '../types'

module.exports = (schema = {}) ->
  switch schema?.type
    when "string" then types.String
    else types.Any