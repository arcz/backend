_   = require 'lodash'
log = require '../../../lib/log'

removeProhibitedKeys = (obj) ->
  _.omit obj, [ 'questions', 'meta' ]

module.exports = (app) ->
  app.all '/api/user', (req, res, next) ->
    return next() if req.user
    res.status(403).send('Not logged in')

  app.get "/api/user", (req, res) ->
    user = req.user
    res.send removeProhibitedKeys user.toJSON()

  app.put "/api/user/start", (req, res) ->
    user = req.user
    user.start req.body, (err, user) ->
      log.error err if err
      res.send removeProhibitedKeys user.toJSON()

  app.post "/api/user/finish", (req, res) ->
    user = req.user
    user.finish (err, user) ->
      log.error err if err
      res.send removeProhibitedKeys user.toJSON()
