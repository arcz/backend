mongoose = require 'mongoose'

require '../../../server/models/question'
Question = mongoose.model 'Question'

describe 'Question model', ->
  it 'should exist', ->
    Question.should.be.ok




