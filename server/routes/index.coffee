requireDirSync = require 'require-dir-sync'
path           = require 'path'

getRoutes = ->
  requireDirSync __dirname,
    recursive: true
    ignore: /index.*$/

module.exports = (app) ->
  route app for name, route of getRoutes()
