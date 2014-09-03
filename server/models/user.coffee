mongoose = require 'mongoose'
_        = require 'lodash'

questions  = require '../questions'
config     = require '../../config/config'
quizConfig = require '../../config/quiz'

fields = require './user.fields'

module.exports = UserSchema = mongoose.Schema fields,
  toObject: virtuals: true
  toJSON: virtuals: true

UserSchema.options.toJSON =
  transform: (doc, user) ->
    user.id = user._id
    # Hide all the fields that start with _
    delete user[key] for key of user when key.charAt(0) is '_'
    user

# Build questions from questions list before saving
UserSchema.pre 'save', (next) ->
  questionList = questions.getRandomQuestionsCombined quizConfig.count
  @questions.push question for question in questionList
  next()

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

# UserSchema.methods.answer = (type, id, result, cb) ->


UserSchema.methods.isFinished = (cb) ->
  if @durationLeft <= 0 and not @finished
    @finish()
    @durationTook = quizConfig.duration
    @save cb
  else
    cb null, this

UserSchema.virtual('admin').get ->
  @email in config.admins
