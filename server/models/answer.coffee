mongoose = require 'mongoose'

fields =
  answeredAt:
    type    : Date
    default : Date.now

  content:
    type     : mongoose.Schema.Types.Mixed
    required : true
    trim     : true

  corrent: Boolean
module.exports = AnswerSchema = mongoose.Schema fields,
  toObject : virtuals : true
  toJSON   : virtuals : true

AnswerSchema.virtual('id').get ->
  @_id.toHexString()
