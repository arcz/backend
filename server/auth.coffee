passport = require 'passport'
path     = require 'path'

User       = require './models/user'
requireDir = require '../lib/require-dir'

# Load all the strategies
strategies = requireDir path.resolve __dirname, './strategies'
passport.use strategy for strategy in strategies

passport.serializeUser (user, done) ->
  done null, user.id

passport.deserializeUser (id, done) ->
  User.findById id, done

