_        = require 'lodash'
log      = require '../../../lib/log'
{ User } = require '../../models'

module.exports = (app) ->
  app.all '/api/admin*', (req, res, next) ->
    return next() if req.user?.admin
    res.status(403).send 'Not an admin'

  app.get '/api/admin/users', (req, res) ->
    User.find (err, users) ->
      log.error if err
      res.send users


  app.get '/api/admin/users/:id', (req, res) ->
    User.findById req.params.id, (err, doc) ->
      res.send JSON.stringify doc
