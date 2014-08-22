mongoose = require 'mongoose'

module.exports =
  email: String
  name: String
  avatar: String
  url: String
  authType: String
  startedAt: Date
  durationTook: Number
  finished:
    type    : Boolean
    default : false
  testIndecies: [Number]
  codeAsignIndecies: [Number]
  codeSolutions: mongoose.Schema.Types.Mixed
  testAnswers: mongoose.Schema.Types.Mixed
  result:
    test:
      totalScore: Number
      normScore: Number
      rightAnswers: Number
      notGivenRightAnswers: Number
      wrongAnswers: Number
    coding:
      rightSolutions: Number
      wrongSolutions: Number
  preferedLanguage:
    type: String
    enum: ['javascript', 'coffeescript']

