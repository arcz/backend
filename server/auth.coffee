requireDirSync = require 'require-dir-sync'
passport       = require 'passport'
path           = require 'path'
log            = require '../lib/log'

{ User }   = require './models'

# Load all the strategies
strategies = requireDirSync path.resolve __dirname, './strategies'
passport.use strategy for name, strategy of strategies

passport.serializeUser (user, done) ->
  done null, user.id

passport.deserializeUser (id, done) ->
  User.findById id, (err, user) ->
    if err
      log.error err
      return done err, null
    return done null, null unless user
    user.validateState done
