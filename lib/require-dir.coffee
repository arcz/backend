fs   = require 'fs'
path = require 'path'

isValidFile = (fileName) ->
  return if fileName is "index.coffee"
  ext = fileName.substr fileName.lastIndexOf('.') + 1
  ext in [ 'js', 'coffee' ]

module.exports = (folder) ->
  res = []
  fs.readdirSync(folder).forEach (file) ->
    return unless isValidFile file
    name = file.substr 0, file.lastIndexOf('.')
    res.push require path.join folder, name
  res
