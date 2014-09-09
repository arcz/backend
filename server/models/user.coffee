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
# Removes questions object
UserSchema.options.toJSON =
  transform: (doc) ->
    user = doc.toObject()
    # Hide all the fields that start with _
    delete user[key] for key of user when key.charAt(0) is '_'
    delete user.questions
    user

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

UserSchema.methods.answer = (questionId, answer = {}, cb) ->
  question = _.find @questions, { id: questionId }

  return cb(null, null) if @timeLeft <= 0
  return cb(null, null) unless question
  return cb(null, null) if not question.multipleAnswers and question.answers.length

  fileName = question.fileName
  content  = answer.content
  questions.findAndValidate fileName, content, (err, valid) =>
    log.error err if err
    return cb err, null if err
    answer.valid = valid
    id           = question.answers.push answer
    @markModified 'question.anaswers'
    @save (err, user) ->
      cb err, question.answers[id - 1]

UserSchema.virtual('isStarted').get ->
  @startedAt?

UserSchema.virtual('admin').get ->
  @email in config.admins

UserSchema.virtual('timeLeft').get ->
  return unless @isStarted
  res = Math.ceil (@timeTotal - (Date.now() - @startedAt.getTime()))
  res = 0 if res < 0
  res

UserSchema.virtual('timeTotal').get ->
  quizConfig.duration

UserSchema.virtual('id').get ->
  @_id.toHexString()
