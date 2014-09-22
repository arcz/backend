GitHubStrategy = require('passport-github').Strategy

{ User }   = require '../models'
{ github } = require '../../config/strategies'

module.exports = new GitHubStrategy github, (accessToken, token, dataObj, done) ->
  data   = dataObj._json
  fields =
    email: data.email
    avatar: data.avatar_url
    url: data.html_url
    name: data.name
    authType: 'github'

  User.findOrCreate fields, done
