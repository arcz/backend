mongoose = require 'mongoose'
fields   = require './question.fields'

_ = require 'lodash'

module.exports = QuestionSchema = mongoose.Schema fields,
  toObject : virtuals : true
  toJSON   : virtuals : true

# Removes all keys that start with _
# Removes fileName
QuestionSchema.options.toJSON =
  transform: (doc) ->
    question = doc.toObject()
    _.omit question, (val, key) ->
      key is 'fileName' or key.charAt(0) is '_'

QuestionSchema.virtual('id').get ->
  @_id.toHexString()
