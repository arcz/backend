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
    question.validate content, (error, result) ->
      cb error, result
  catch error
    cb error, null

exports.load = (dir) =>
  files = requireDirSync dir
  @list = _(files).map setFileName
                  .map setExpectedAnswer
                  .filter validateQuestion
                  .value()

exports.getRandomQuestions = (type, nr = 1) =>
  throw new Error("No question type defined") unless type
  _(@list).filter({ type })
          .shuffle()
          .first(nr)
          .value()

exports.getRandomQuestionsCombined = (obj = {}) =>
  _(obj).map swapArgs @getRandomQuestions
        .flatten()
        .value()
