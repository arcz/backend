passport = require 'passport'
{ redirects } = require '../../../config/strategies'

module.exports = (app) ->
  app.get '/auth/facebook', passport.authenticate 'facebook'

  app.get '/auth/facebook/callback', passport.authenticate 'facebook', redirects

