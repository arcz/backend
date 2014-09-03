_ = require 'lodash'

module.exports = (array) ->
  res = {}
  throw new Error 'No array given' unless _.isArray array
  res[val + 1] = key for key, val in array
  res
