passport = require 'passport'

{ linkedIn, redirects } = require '../../../config/strategies'

module.exports = (app) ->
  app.get '/auth/linkedin', passport.authenticate 'linkedin',
      scope: ['r_emailaddress', 'r_basicprofile']
      state: linkedIn.state

  app.get '/auth/linkedin/callback', passport.authenticate 'linkedin', redirects

