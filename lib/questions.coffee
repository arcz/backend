requireDirSync = require 'require-dir-sync'
_              = require 'lodash'

arrToObj         = require '../lib/arr-to-obj'
validateQuestion = require '../lib/validate-question'


setFileName = (obj, key) ->
  obj.fileName = key
  obj

setExpectedAnswer = (obj, key) ->
  obj.expectedAnswer = typeof obj.validate is 'function'
  obj

setQuestionGroup = (obj, key) ->
  obj.group ?= '*'
  obj

# Swap the arguments of a function
swapArgs = (fn) -> (a, b) -> fn b, a

# All questions that we have
exports.list = []

exports.clear = =>
  @list = []

exports.findByFilename = (fileName) ->
  _.find @list, { fileName }

# Finds the module by its filename and validates it
#
# Callback is returned with (error, result) params
# If the module has no #validate method then the callback result
# will be null
exports.findAndValidate = (fileName, content, cb) =>
  question = @findByFilename fileName
  unless question
    error = new Error 'Question not found'
    return cb error, null
  return cb null, null unless question.validate?
  try
    question.validate content, cb
  catch error
    cb error, null

exports.load = (dir) =>
  files = requireDirSync dir, recursive: true
  @list = _(files).map setFileName
                  .map setQuestionGroup
                  .map setExpectedAnswer
                  .filter validateQuestion
                  .value()

exports.getRandomQuestions = (group = '*', nr = 1) =>
  _(@list).filter({ group })
          .shuffle()
          .first(nr)
          .value()

exports.getRandomQuestionsCombined = (obj = {}) =>
  _(obj).map swapArgs @getRandomQuestions
        .flatten()
        .value()
