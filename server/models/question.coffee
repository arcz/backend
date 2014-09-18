mongoose = require 'mongoose'
fields   = require './question.fields'

_ = require 'lodash'

module.exports = QuestionSchema = mongoose.Schema fields,
  toObject : virtuals : true
  toJSON   : virtuals : true

QuestionSchema.pre 'save', (next) ->
  @schema.eachPath (path, schemaType) =>
    if schemaType.instance is 'String'
      @set path, _.escape @get path
  next()

# Removes all keys that start with _
# Removes fileName
QuestionSchema.options.toJSON =
  transform: (doc) ->
    question = doc.toObject()
    _.omit question, (val, key) ->
      key is 'fileName' or key.charAt(0) is '_'

QuestionSchema.virtual('id').get ->
  @_id.toHexString()

QuestionSchema.virtual('answer').get ->
  _.last(@answers) or null
