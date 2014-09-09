mongoose = require 'mongoose'

module.exports = AnswerSchema = mongoose.Schema
  answeredAt:
    type    : Date
    default : Date.now

  content:
    type     : mongoose.Schema.Types.Mixed
    required : true
    trim     : true

  corrent: Boolean

AnswerSchema.virtual('id').get ->
  @_id.toHexString()
