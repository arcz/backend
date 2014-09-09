_ = require 'lodash'

# Question types and their required fields
TYPES =
  checkbox : [ 'name', 'description', 'variants' ]
  code     : [ 'name', 'description', 'code' ]
  text     : [ 'name', 'description' ]
  radio    : [ 'name', 'description', 'variants' ]

removeNilFields = (obj) ->
  _.transform obj, (obj, val, key) ->
    obj[key] = val if val?

hasAllValidFields = (type, keys) ->
  requiredFields = TYPES[type]
  return false unless requiredFields
  _.every requiredFields, (field) ->
    _.contains keys, field

module.exports = (obj = {}) ->
  return false if _.isEmpty removeNilFields obj
  hasAllValidFields obj.type, _.keys obj
