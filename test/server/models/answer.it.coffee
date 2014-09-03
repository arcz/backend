mongoose = require 'mongoose'

AnswerSchema = require '../../../server/models/answer'
Answer = mongoose.model 'Answer', AnswerSchema

describe 'Answer model', ->
  it 'should exist', ->
    Answer.should.be.ok
