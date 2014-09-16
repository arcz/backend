requireDirSync = require 'require-dir-sync'
express        = require 'express'
path           = require 'path'
passport       = require 'passport'

# Express middleware
bodyParser     = require 'body-parser'
cookieParser   = require 'cookie-parser'
expressSession = require 'express-session'

config     = require '../config/config'
quizConfig = require '../config/quiz'

log        = require '../lib/log'

# Express configuration
app = express()
env = process.env.NODE_ENV or 'development'

# Development only settings
if env is 'development'
  log.warn 'Running in development mode'
  # Serve static files
  log.warn "Serving static files from #{config.frontend}"
  app.use require('serve-static') config.frontend
  # Analyse the eventloop
  timeEv = require 'time-eventloop'
  timeEv.start interval: 10

app.use bodyParser.json()
app.use cookieParser()
app.set "port", process.env.PORT or 3000
app.use expressSession
  secret: config.sessionKey
  resave: true
  saveUninitialized: true

# Passport Strategies
require './auth'
app.use passport.initialize()
app.use passport.session()

# initialize all routes
require('./routes') app

# Initialize the db connection
require './db'

# Require all the questions
require('../lib/questions').load quizConfig.dir

# Start the application
app.listen process.env.PORT or 3000, ->
  log.success "Lobzik listening on port #{app.get 'port'}"
