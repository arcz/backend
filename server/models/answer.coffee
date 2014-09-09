mongoose = require 'mongoose'

module.exports = AnswerSchema = mongoose.Schema
  answeredAt:
    type    : Date
    default : Date.now

  content:
    type     : String
    required : true
    trim     : true

  corrent: Boolean

AnswerSchema.virtual('id').get ->
  @_id.toHexString()
