requireDir       = require '../lib/require-dir'
validateQuestion = require '../lib/validate-question'

# All questions that we have
exports.list = {}

exports.clear = =>
  @list = {}

exports.load = (dir) =>
  @list = requireDir(dir).filter validateQuestion

