mongoose = require 'mongoose'

QuestionSchema = require './question'

module.exports =
  avatar     : String
  url        : String
  finishedAt : Date

  email:
    type     : String
    trim     : true
    required : true

  name:
    type     : String
    trim     : true
    required : true

  authType:
    type     : String
    required : true

  startedAt:
    type    : Date

  finished:
    type    : Boolean
    default : false

  questions: [ QuestionSchema ]
