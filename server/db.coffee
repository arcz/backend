config = require '../config/database'
log    = require '../lib/log'

mongoose = require "mongoose"
mongoose.connect config.url

# Require all the models so they would get cached
require './models'

module.exports = db = mongoose.connection

db.on 'error', (error) ->
  log.error "Failed to connect to db: #{error}"

db.once 'open', ->
  log.success "Connected to mongo"
