_ = require 'lodash'

# Question types and their required fields
REQUIRED_FIELDS = [ 'type', 'name', 'description' ]

removeNilFields = (obj) ->
  _.transform obj, (obj, val, key) ->
    obj[key] = val if val?

module.exports = (obj = {}) ->
  return false if _.isEmpty removeNilFields obj
  keys = _.keys obj
  _.every REQUIRED_FIELDS, (field) ->
    _.contains keys, field
