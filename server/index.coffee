bugsnag  = require "bugsnag"
express  = require "express"
path     = require "path"
passport = require "passport"

config     = require "../config/config"
requireDir = require "../lib/require-dir"
log        = require "../lib/log"

# Passport Strategies
require './auth'

# Express configuration
app = express()

app.use express.json()
app.use express.urlencoded()
app.use express.cookieParser()
app.use express.session secret: config.sessionKey
app.use express.static path.resolve __dirname, '../app'
app.use passport.initialize()
app.use passport.session()
app.set "port", process.env.PORT or 3000

# Development only settings
app.configure 'development', ->
  log.warn "Running in development mode"
  app.use express.errorHandler dumpExceptions: true, showStack: true
  app.use require('coffee-middleware')
    src: path.join __dirname, '../app'
    compress: false

# initialize all routes
routes = requireDir path.resolve __dirname, './routes'
route app for route in routes

# Start the application
app.listen process.env.PORT or 3000, ->
  log.success "Lobzik listening on port #{app.get 'port'}"
