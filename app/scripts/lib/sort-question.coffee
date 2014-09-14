_ = require 'lodash'

BOTTOM_EL_CONST = 99999

sortPredicate = (sortOrder, question) ->
  index = _.indexOf sortOrder, question.group
  # If the element does not exist in the array
  # then return A really - really - really high constant to push it to bottom
  return BOTTOM_EL_CONST unless ~index
  index

module.exports = (questions = [], sortOrder) ->
  predicate = if sortOrder
    _.partial sortPredicate, sortOrder
  else
    'group'
  _.sortBy questions, predicate
