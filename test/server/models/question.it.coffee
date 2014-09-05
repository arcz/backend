mongoose = require 'mongoose'
assert   = require 'assert'

helpers  = require '../../test-helpers'

QuestionSchema = require '../../../server/models/question'
Question = mongoose.model 'Question', QuestionSchema

describe 'Question model', ->
  REQUIRED_FIELDS = null
  before helpers.connect
  beforeEach ->
    REQUIRED_FIELDS = { 'description', 'name', 'type' }

  it 'should exist', ->
    Question.should.be.ok

  describe '#toJSON', ->
    it 'should hide _id', (done) ->
      Question.create REQUIRED_FIELDS, (err, question) ->
        assert question.toJSON()._id is undefined
        done err

    it 'should hide __v', (done) ->
      Question.create REQUIRED_FIELDS, (err, question) ->
        assert question.toJSON().__v is undefined
        done err

  describe '#id', ->
    it 'should set id', (done) ->
      Question.create REQUIRED_FIELDS, (err, question) ->
        question.id.should.be.ok
        done err
