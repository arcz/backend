FacebookStrategy = require('passport-facebook').Strategy

{ User }     = require '../models'
{ facebook } = require '../../config/strategies'

getAvatarUrl = (id) ->
  "https://graph.facebook.com/#{id}/picture?type=large"

module.exports = new FacebookStrategy facebook, (accessToken, token, dataObj, done) ->
  data = dataObj._json
  User.findOrCreate done,
    email: data.email
    avatar: getAvatarUrl data.id
    url: data.link
    name: "#{data.first_name} #{data.last_name}"
    authType: 'facebook'

