fs   = require 'fs'
path = require 'path'

VALID_EXTENSIONS = [ 'js', 'coffee', 'json' ]

isValidFile = (fileName) ->
  ext = fileName.substr fileName.lastIndexOf('.') + 1
  ext in VALID_EXTENSIONS

module.exports = (folder) ->
  res = []
  fs.readdirSync(folder).forEach (file) ->
    return unless isValidFile file
    name = file.substr 0, file.lastIndexOf('.')
    res.push require path.join folder, name
  res
