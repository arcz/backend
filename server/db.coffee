config = require '../config/database'

mongoose = require("mongoose")
mongoose.connect config.url

db = mongoose.connection
db.on 'error', console.error.bind console, 'connection error:'
db.once 'open', ->
  # start server
  console.log "Trying to start on #{app.get('port')} in #{process.env.NODE_ENV} env"
