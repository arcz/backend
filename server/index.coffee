requireDirSync = require 'require-dir-sync'
express        = require 'express'
path           = require 'path'
passport       = require 'passport'

# Express middleware
bodyParser     = require 'body-parser'
cookieParser   = require 'cookie-parser'
expressSession = require 'express-session'
coffee         = require 'coffee-middleware'
serveStatic    = require 'serve-static'

config     = require '../config/config'
quizConfig = require '../config/quiz'

log        = require '../lib/log'

# Express configuration
app = express()
env = process.env.NODE_ENV or 'development'

# Development only settings
if env is 'development'
  log.warn 'Running in development mode'
  app.use coffee
    src: path.join __dirname, '../app'
    compress: false

app.use bodyParser.json()
app.use cookieParser()
app.use serveStatic path.join __dirname, '../app'
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
routes = requireDirSync path.resolve __dirname, './routes'
route app for name, route of routes

# Initialize the db connection
require './db'

# Require all the questions
require('./questions').load quizConfig.dir

# Start the application
app.listen process.env.PORT or 3000, ->
  log.success "Lobzik listening on port #{app.get 'port'}"
