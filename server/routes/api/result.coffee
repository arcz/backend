_ = require 'lodash'

removeProhibitedKeys = (questions) ->
  _.map questions, (question) ->
    _.omit question, 'answers'

module.exports = (app) ->
  app.all '/api/results', (req, res, next) ->
    user     = req.user
    timeLeft = user?.timeLeft
    return next() if timeLeft is 0
    msg = if not user then 'Not logged in' else 'Not finished yet'
    res.status(403).send msg

  app.get "/api/results", (req, res) ->
    user = req.user
    res.send removeProhibitedKeys user.toJSON().questions
