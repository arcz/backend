mongoose = require 'mongoose'
_        = require 'lodash'

questions  = require '../questions'
config     = require '../../config/config'
quizConfig = require '../../config/quiz'
log        = require '../../lib/log'

module.exports = UserSchema = mongoose.Schema require('./user.fields'),
  toObject : virtuals : true
  toJSON   : virtuals : true

# Removes all keys that start with _
UserSchema.options.toJSON =
  transform: (doc) ->
    user = doc.toObject()
    _.omit user, (val, key) -> key.charAt(0) is '_'

# Finds a current user or creates a new one
#
# If we have found a current user by its url and it has a different email
# then lets update the users email and return the updated user
UserSchema.statics.findOrCreate = (data, cb) ->
  { email, url } = data
  condition = $or: [{email}, {url}]
  @findOne condition, (err, user) =>
    return cb err, null if err
    return @create data, cb unless user
    # So it seems that the users email is changed
    # lets update the user
    if user.email isnt email
      user.email = email
      user.save cb
    else
      cb null, user

UserSchema.methods.start = ({ email, name, address } = {}, cb) ->
  return cb(null, this) if @isStarted
  listQuestions = questions.getRandomQuestionsCombined quizConfig.count

  @questions.push question for question in listQuestions
  @address = address if address?
  @email   = email if email?
  @name    = name  if name?

  @startedAt = new Date()
  @save cb

timeLeftError = ->
  new Error 'Tried to answer after the time was up'

noQuestionsError = ->
  new Error 'Invalid questionId'

multipleAnswerError = ->
  new Error 'Tried to answer a question twice'

UserSchema.methods.answer = (questionId, answer = {}, cb) ->
  question = _.find @questions, { id: questionId }

  return cb(timeLeftError(), null) if @timeLeft <= 0
  return cb(noQuestionsError(), null) unless question
  return cb(multipleAnswerError(), null) if not question.multipleAnswers and question.answers.length

  fileName = question.fileName
  content  = answer.content
  questions.findAndValidate fileName, content, (err, valid) =>
    log.error err if err
    return cb err, null if err
    answer.valid = valid
    answerCount  = question.answers.push answer
    @markModified 'question.answers'
    @save (err, user) ->
      cb err, question.answers[answerCount - 1]

UserSchema.methods.finish = (cb) ->
  return cb null, this unless @startedAt
  @finishedAt = Date.now()
  @save cb

UserSchema.virtual('isStarted').get ->
  @startedAt?

UserSchema.virtual('admin').get ->
  @email in config.admins

UserSchema.virtual('timeLeft').get ->
  return unless @isStarted
  return 0 if @finishedAt
  res = Math.ceil (@timeTotal - (Date.now() - @startedAt.getTime()))
  res = 0 if res < 0
  res

UserSchema.virtual('timeTotal').get ->
  quizConfig.duration

UserSchema.virtual('id').get ->
  @_id.toHexString()
