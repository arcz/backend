passport = require 'passport'

{ redirects } = require '../../../config/strategies'

module.exports = (app) ->
  app.get '/auth/github', passport.authenticate 'github'

  app.get '/auth/github/callback',
    passport.authenticate 'github', redirects
