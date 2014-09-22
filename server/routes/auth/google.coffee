passport = require 'passport'
{ redirects } = require '../../../config/strategies'

module.exports = (app) ->
  app.get '/auth/google', passport.authenticate 'google',
    scope: ['email', 'profile']

  app.get '/auth/google/callback', passport.authenticate 'google', redirects

