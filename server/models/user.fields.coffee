mongoose = require 'mongoose'

module.exports =
  email:
    type: String
    trim: true
    required: true
  name:
    type: String
    trim: true
    required: true
  avatar: String
  url: String
  authType: String
  startedAt:
    type: Date
    default: Date.now
  finishedAt: Date

  finished:
    type    : Boolean
    default : false

  questions: mongoose.Schema.Types.Mixed
  answers: [Object]


