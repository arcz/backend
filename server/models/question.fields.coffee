mongoose     = require 'mongoose'
AnswerSchema = require './answer'

module.exports =
  answers: [ AnswerSchema ]
  content: mongoose.Schema.Types.Mixed
  variants: mongoose.Schema.Types.Mixed

  group:
    type     : String
    required : true

  name:
    type     : String
    trim     : true
    required : true

  fileName:
    type     : String
    required : true

  description:
    type     : String
    trim     : true
    required : true

  coenficent:
    type    : Number
    default : 1

  type:
    type     : String
    required : true

  expectedAnswer:
    type     : Boolean
    required : true


