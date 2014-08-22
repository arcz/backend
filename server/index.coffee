express  = require "express"
path     = require "path"
passport = require "passport"

# Express middleware
bodyParser     = require 'body-parser'
cookieParser   = require 'cookie-parser'
expressSession = require 'express-session'
errorHandler   = require 'error-handler'
coffee         = require 'coffee-middleware'
serveStatic    = require 'serve-static'

config     = require "../config/config"
requireDir = require "../lib/require-dir"
log        = require "../lib/log"

# Passport Strategies
require './auth'

# Express configuration
app = express()
env = process.env.NODE_ENV or 'development'

app.use bodyParser.json()
app.use cookieParser()
app.use serveStatic path.join __dirname, '../app'
app.use passport.initialize()
app.use passport.session()
app.set "port", process.env.PORT or 3000

# Development only settings
if env is 'development'
  log.warn "Running in development mode"
  app.use coffee
    src: path.join __dirname, '../app'
    compress: false

# initialize all routes
routes = requireDir path.resolve __dirname, './routes'
route app for route in routes

# Initialize the db connection
require './db'

# Start the application
app.listen process.env.PORT or 3000, ->
  log.success "Lobzik listening on port #{app.get 'port'}"
