GitHubStrategy = require('passport-github').Strategy
User           = require '../models/user'

{ github } = require '../../config/strategies'

requiredData =
  clientID     : github.appId,
  clientSecret : github.appSecret,
  callbackURL  : "/auth/github/callback"
  scope        : ['user:email']

module.exports = new GitHubStrategy requiredData, (accessToken, token, dataObj, done) ->
  data = dataObj._json
  User.findOrCreateUser done,
    email: data.email
    avatar: data.avatar_url
    url: data.html_url
    name: data.name
    authType: 'github'
