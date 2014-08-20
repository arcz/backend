passport = require 'passport'

{ linkedIn } = require '../../config/strategies'

module.exports = (app) ->
  app.get '/auth/linkedin',
    passport.authenticate 'linkedin',
      scope: ['r_emailaddress', 'r_basicprofile']
      state: linkedIn.state

  app.get '/auth/github', passport.authenticate 'github'

  app.get '/logout', (req, res) ->
    req.logout()
    res.redirect('/')

  app.get '/auth/linkedin/callback',
    passport.authenticate 'linkedin',
      successRedirect: '/'
      failureRedirect: '/'

  app.get '/auth/github/callback',
    cb = (req, res) ->
      res.redirect '/'
    passport.authenticate 'github', failureRedirect: '/', cb

