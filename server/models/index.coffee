mongoose       = require 'mongoose'
requireDirSync = require 'require-dir-sync'

removeExtension = (name) ->
  name.substr 0, name.lastIndexOf('.')

capitalise = (string) ->
  string.charAt(0).toUpperCase() + string.slice(1)

models = requireDirSync __dirname, ignore: [ /\.fields\.coffee/, /^index\./ ]

# Loop through all the schemas and register them
for name, Schema of models
  shortName = capitalise removeExtension name
  exports[shortName] = mongoose.model shortName, Schema
