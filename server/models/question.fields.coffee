mongoose     = require 'mongoose'
AnswerSchema = require './answer'

module.exports =
  answers: [ AnswerSchema ]
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
    type: Number
    default: 1

  type:
    type     : String
    required : true

  multipleAnswers:
    type    : Boolean
    default : false

  content:
    type : String

  code:
    type: String

  variants: Object
