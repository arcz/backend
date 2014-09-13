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
      res.send users.map (user) -> user.toJSON()
