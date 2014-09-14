_   = require 'lodash'
env = require '../../config/env'

module.exports = (app) ->
  app.get '/env', (req, res) ->
    res.send env


