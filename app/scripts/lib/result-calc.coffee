_ = require 'lodash'

sumByCoenfiecent = (sum, question) ->
  sum + question.coenficent

module.exports = (questions = []) ->
  answerable = _.filter questions, { expectedAnswer: true }
  correct    = _.filter answerable, (question) -> question.answer?.valid
  return 1 if answerable.length is 0
  return 0 if correct.length is 0
  sumAnswerable = _.reduce answerable, sumByCoenfiecent, 0
  sumCorrect    = _.reduce correct, sumByCoenfiecent, 0
  sumCorrect / sumAnswerable
