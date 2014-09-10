_        = require 'lodash'
mongoose = require 'mongoose'

fields =
  answeredAt:
    type    : Date
    default : Date.now

  content:
    type     : mongoose.Schema.Types.Mixed
    required : true
    trim     : true

  valid: Boolean

module.exports = AnswerSchema = mongoose.Schema fields,
  toObject : virtuals : true
  toJSON   : virtuals : true

AnswerSchema.virtual('id').get ->
  @_id.toHexString()

# Removes all keys that start with _
AnswerSchema.options.toJSON =
  transform: (doc) ->
    answer = doc.toObject()
    _.omit answer, (val, key) -> key.charAt(0) is '_'
