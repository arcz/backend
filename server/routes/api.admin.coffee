UserArrayFormatter = require '../../lib/user-array-formatter'
_                  = require 'lodash'

simpleData = (user) ->
  fields   = [
    'id'
    'name',
    'email',
    'result',
    'resultPercent',
    'avatar',
    'url'
  ]
  userData = _.pick user, fields,
  JSON.stringify(userData)

module.exports = (app) ->
  app.all '/api/admin*', (req, res, next) ->
    if req.user?.isAdmin
      next()
    else
      res.send(403, 'Not an admin')

  app.get '/api/admin/users', (req, res) ->
    res.contentType('json')
    User.find()
      .stream(transform: simpleData)
      .pipe(new UserArrayFormatter()).pipe(res)

  app.get '/api/admin/users/:id', (req, res) ->
    res.contentType('json')
    User.findById req.params.id, (err, doc) ->
      res.send JSON.stringify(doc)
