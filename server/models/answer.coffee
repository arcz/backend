mongoose = require 'mongoose'
fields   = require './answer.fields'

module.exports = AnswerSchema = mongoose.Schema fields

mongoose.model 'Answer', AnswerSchema
