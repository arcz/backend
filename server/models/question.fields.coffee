mongoose     = require 'mongoose'
AnswerSchema = require './answer'

module.exports =
  answers : [ AnswerSchema ]
  content : mongoose.Schema.Types.Mixed
  opts    : mongoose.Schema.Types.Mixed

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


  # If the quesiton has validate method
  # then expectedAnswer will be set as true.
  #
  # Will be used to tranverse the validate object later on
  expectedAnswer:
    type     : Boolean
    required : true


