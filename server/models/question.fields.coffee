mongoose     = require 'mongoose'
AnswerSchema = require './answer'

module.exports =
  answers: [ AnswerSchema ]
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

  content:
    type : String

  expectedAnswer:
    type     : Boolean
    required : true

  variants: Object

