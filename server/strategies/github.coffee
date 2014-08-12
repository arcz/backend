GitHubStrategy = require('passport-github').Strategy
User           = require '../models/user'

config = require '../../config/config'

requiredData =
  clientID: config.github.appId,
  clientSecret: config.github.appSecret,
  callbackURL: "/auth/github/callback"
  scope: ['user:email']


module.exports = new GitHubStrategy requiredData,
  (accessToken, refreshToken, profile, done) ->
    profile = profile._json
    next = ->
      console.log 'findOrCreateUser', profile
      User.findOrCreateUser done,
        email: profile.email or profile.html_url
        avatar: profile.avatar_url
        url: profile.url
        name: profile.name
        authType: 'github'

    if profile.email
      console.log "email is there #{profile.email}"
      next()
    else
      url = "https://api.github.com/user/emails?access_token=#{accessToken}"
      request
        url: url
        headers: 'User-Agent': 'Lobzik'
      , (error, response, body) ->
        if !error && response.statusCode == 200
          emails = JSON.parse(body)
          console.log 'emails:', emails
          for email in emails
            if email.indexOf('noreply.github.com') is -1
              profile.email = email
              break
        else
          console.log "Asking for email fails", response.statusCode, body

        return next()

