module.exports = (app) ->
  app.all '/api/user', (req, res, next) ->
    if req.user
      next()
    else
      res.send(403, 'Not logged in')

  app.get "/api/user", (req, res) ->
    user = req.user
    user.checkIfFinished ->
      res.send user.publicJSON()

  app.put "/api/user", (req, res) ->
    user = req.user

    if user.finished
      return res.send 403, 'Already finished'

    finished = user.checkIfFinished ->
      if user.finished
        res.send 403, 'Already finished'
    return if finished

    codeSolutions = req.body?.codeSolutions or {}
    for name, {code:code, pass:pass} of codeSolutions
      lastSolution = _.last user.codeSolutions[name]
      if not lastSolution or lastSolution.code isnt code
        user.codeSolutions[name].push code:code, pass:pass
        user.markModified('codeSolutions')

    testAnswers = req.body?.testAnswers or {}
    for name, answers of testAnswers
      user.testAnswers[name] = answers
      user.markModified 'testAnswers'

    if req.body?.finished and not user.finished
      user.finishUser()

    user.preferedLanguage = req.body?.preferedLanguage

    user.save (err, user) ->
      return res.send(400, err) if err
      res.send user.publicJSON()

