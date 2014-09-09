module.exports = (app) ->
  app.all '/api/questions/**', (req, res, next) ->
    return next() if req.user
    res.status(403).send('Not logged in')

  app.get "/api/questions", (req, res) ->
    user = req.user
    res.send user.questions
