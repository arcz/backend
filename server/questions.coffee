requireDirSync = require 'require-dir-sync'
_              = require 'lodash'

arrToObj         = require '../lib/arr-to-obj'
validateQuestion = require '../lib/validate-question'

# All questions that we have
exports.list = []

exports.clear = =>
  @list = []

setFileName = (obj, key) ->
  obj.fileName = key
  obj

exports.load = (dir) =>
  files = requireDirSync dir

  @list = _(files).map setFileName
                  .filter validateQuestion
                  .value()

exports.getRandomQuestions = (type, nr = 1) =>
  throw new Error("No question type defined") unless type
  _(@list).filter({ type })
          .shuffle()
          .first(nr)
          .value()

# Swap the arguments of a function
swapArgs = (fn) -> (a, b) -> fn b, a

exports.getRandomQuestionsCombined = (obj = {}) =>
  _(obj).map swapArgs @getRandomQuestions
        .flatten()
        .value()
