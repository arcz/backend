config = require '../config/database'
log    = require '../lib/log'

mongoose = require "mongoose"
mongoose.connect config.url

module.exports = db = mongoose.connection

db.on 'error', (error) ->
  log.error "MongoDB: failed to connect to [#{config.url}]"
  process.exit 1

db.once 'open', ->
  log.success "Connected to mongo"
