_ = require 'lodash'

removeProhibitedKeys = (questions) ->
  _.map questions, (question) ->
    _.omit question, 'answers'

module.exports = (app) ->
  app.all '/api/questions', (req, res, next) ->
    return next() if req.user
    res.status(403).send('Not logged in')

  app.get "/api/questions", (req, res) ->
    user = req.user
    res.send removeProhibitedKeys user.toJSON().questions
