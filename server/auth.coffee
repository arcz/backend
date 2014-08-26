requireDirSync = require 'require-dir-sync'
passport       = require 'passport'
path           = require 'path'

{ User }   = require './models'

# Load all the strategies
strategies = requireDirSync path.resolve __dirname, './strategies'
passport.use strategy for name, strategy of strategies

passport.serializeUser (user, done) ->
  done null, user.id

passport.deserializeUser (id, done) ->
  User.findById id, done

