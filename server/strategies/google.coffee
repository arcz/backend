GoogleStrategy = require('passport-google-oauth').OAuth2Strategy

{ User }   = require '../models'
{ google } = require '../../config/strategies'

module.exports = new GoogleStrategy google, (accessToken, token, dataObj, done) ->
  data = dataObj._json
  User.findOrCreate done,
    email: data.email
    avatar: data.picture
    url: data.link
    name: data.name
    authType: 'google'
