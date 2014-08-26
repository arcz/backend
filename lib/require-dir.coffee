fs   = require 'fs'
path = require 'path'

VALID_EXTENSIONS = [ 'js', 'coffee', 'json' ]

notIgnored = (fn) -> (fileName, ignore = []) ->
  return if ignore.some (pattern) -> fileName.match pattern
  fn arguments...

isValidFile = notIgnored (fileName, ignore) ->
  ext = fileName.substr fileName.lastIndexOf('.') + 1
  ext in VALID_EXTENSIONS

getFileName = (file) ->
  file.substr 0, file.lastIndexOf('.')

module.exports = (folder, { ignore } = {}) ->
  res    = {}
  ignore = [].concat ignore if ignore
  fs.readdirSync(folder).forEach (file) ->
    return unless isValidFile file, ignore
    fileName  = getFileName file
    res[file] = require path.join folder, fileName
  res
