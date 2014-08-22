_    = require 'lodash'
User = require '../models/user'

USER_FIELDS = [
  'id'
  'name',
  'email',
  'result',
  'resultPercent',
  'avatar',
  'url'
]

simpleData = (user) ->
  JSON.stringify _.pick user, USER_FIELDS

module.exports = (app) ->
  app.all '/api/admin*', (req, res, next) ->
    return next() if req.user?.isAdmin
    res.status(403).send 'Not an admin'

  app.get '/api/admin/users', (req, res) ->
    User.find()
        .stream(transform: simpleData)
        .pipe(res)

  app.get '/api/admin/users/:id', (req, res) ->
    User.findById req.params.id, (err, doc) ->
      res.send JSON.stringify doc
