mongoose     = require 'mongoose'
AnswerSchema = require './answer'

module.exports =
  answers: [ AnswerSchema ]
  name:
    type     : String
    trim     : true
    required : true

  description:
    type     : String
    trim     : true
    required : true

  type:
    type     : String
    required : true

  content:
    type     : String

  code:
    type: String

  variants: Object
