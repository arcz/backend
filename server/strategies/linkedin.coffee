LinkedInStrategy = require('passport-linkedin-oauth2').Strategy
User             = require '../models/user'

{ linkedIn } = require '../../config/strategies'

requiredData =
  clientID: linkedIn.appId,
  clientSecret: linkedIn.appSecret
  callbackURL: '/auth/linkedin/callback'
  scope: [
    'r_emailaddress',
    'r_basicprofile'
  ]
  profileFields: [
    'id',
    'picture-url',
    'first-name',
    'last-name',
    'email-address',
    'public-profile-url'
  ]

module.exports = new LinkedInStrategy requiredData,
  (accessToken, refreshToken, profile, done) ->
    profile = profile._json
    User.findOrCreateUser done,
      email: profile.emailAddress
      avatar: profile.pictureUrl
      url: profile.publicProfileUrl
      name: "#{profile.firstName} #{profile.lastName}"
      authType: 'linkedin'
