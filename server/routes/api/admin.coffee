_        = require 'lodash'
log      = require '../../../lib/log'
{ User } = require '../../models'

module.exports = (app) ->
  app.all '/api/admin*', (req, res, next) ->
    return next() if req.user?.admin
    res.status(403).send 'Not an admin'

  app.get '/api/admin/users', (req, res) ->
    User.findFinished (err, users) ->
      log.error if err
      res.send users.map (user) -> user.toJSON()

  app.get '/api/admin/overview', (req, res) ->
    User.findFinished (err, users) ->
      log.error if err
      res.send finished: users.length

  app.put '/api/admin/update/:id', (req, res) ->
    id   = req.params.id
    meta = req.params.meta
    User.findByIdAndUpdate id, req.body, {}, (err, user) ->
      log.error if err
      res.send user

  app.del '/api/admin/user/:id', (req, res) ->
    id = req.params.id
    User.remove { _id: id }, (err, usr) ->
      if err
        log.error
        res.status(400).send()
      else
        res.status(200).send {}
