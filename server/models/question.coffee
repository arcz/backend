mongoose = require 'mongoose'
fields   = require './question.fields'

module.exports = QuestionSchema = mongoose.Schema fields,
  toObject : virtuals : true
  toJSON   : virtuals : true

# Removes all keys that start with _
QuestionSchema.options.toJSON =
  transform: (doc) ->
    question = doc.toObject()
    # Hide all the fields that start with _
    delete question[key] for key of question when key.charAt(0) is '_'
    question

QuestionSchema.virtual('id').get ->
  @_id.toHexString()
