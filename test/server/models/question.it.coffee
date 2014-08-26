mongoose = require 'mongoose'

QuestionSchema = require '../../../server/models/question'
Question = mongoose.model 'Question', QuestionSchema

describe 'Question model', ->
  it 'should exist', ->
    Question.should.be.ok




