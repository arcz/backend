FacebookStrategy = require('passport-facebook').Strategy
User = require '../models/user.coffee'

{ facebook } = require '../../config/strategies'

getAvatarUrl = (id) ->
  "https://graph.facebook.com/#{id}/picture?type=large"

requiredData =
  clientID     : facebook.appId,
  clientSecret : facebook.appSecret,
  callbackURL  : '/auth/facebook/callback'
  profileFields: ['email', 'first_name', 'last_name', 'link', 'id']

module.exports = new FacebookStrategy requiredData, (accessToken, token, dataObj, done) ->
  data = dataObj._json
  User.findOrCreateUser done,
    email: data.email
    avatar: getAvatarUrl data.id
    url: data.link
    name: "#{data.first_name} #{data.last_name}"
    authType: 'facebook'

