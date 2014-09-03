module.exports = (app) ->
  app.all '/api/user', (req, res, next) ->
    return next() if req.user
    res.status(403).send('Not logged in')

  app.get "/api/user", (req, res) ->
    user = req.user
    res.send user.toJSON()
