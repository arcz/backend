mongoose = require 'mongoose'

QuestionSchema = require './question'

module.exports =
  avatar     : String
  url        : String
  finishedAt : Date
  startedAt  : Date

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

  finished:
    type    : Boolean
    default : false

  address:
    country:
      type: String
      trim: true

    city:
      type: String
      trim: true

    timezone:
      type: String
      trim: true

  questions: [ QuestionSchema ]
