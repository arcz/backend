mongoose = require 'mongoose'
fields   = require './question.fields'

module.exports = QuestionSchema = mongoose.Schema fields


# Register the schema
mongoose.model 'Question', QuestionSchema

