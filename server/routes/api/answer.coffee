log = require '../../../lib/log'
_   = require 'lodash'

removeProhibitedKeys = (answer) ->
  _.omit answer, 'valid'

module.exports = (app) ->
  app.all '/api/answer/**', (req, res, next) ->
    return next() if req.user
    res.status(403).send('Not logged in')

  app.get "/api/answer/:questionId", (req, res) ->
    id   = req.params.questionId
    user = req.user.toJSON()
    question = _.find user.questions, { id }
    answer   = _.last question.answers
    res.send removeProhibitedKeys answer

  app.post "/api/answer/:questionId", (req, res) ->
    id   = req.params.questionId
    user = req.user
    user.answer id, req.body, (err, answer) ->
      log.error err if err
      res.send removeProhibitedKeys answer?.toJSON()
