mongoose = require 'mongoose'

QuestionSchema = require './question'

module.exports =
  avatar     : String
  finishedAt : Date
  startedAt  : Date

  url :
    type     : String
    required : true

  email:
    type     : String
    trim     : true

  name:
    type     : String
    trim     : true
    required : true

  authType:
    type     : String
    required : true

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
