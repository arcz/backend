mongoose = require 'mongoose'

exports.dbURL = 'mongodb://localhost/testlab-test'

# Currently active connection
exports.connection = null

exports.connect = (cb) =>
  return cb() if @connection
  @connection = mongoose.connect @dbURL, cb

exports.disconnect = (cb) =>
  return cb() unless @connection
  @connection.disconnect =>
    @connection = null
    cb()


