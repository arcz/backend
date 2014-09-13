mongoose = require 'mongoose'
assert   = require 'assert'
_        = require 'lodash'

helpers  = require '../../test-helpers'

QuestionSchema = require '../../../server/models/question'
Question = mongoose.model 'Question', QuestionSchema

describe 'Question model', ->
  REQUIRED_FIELDS = null
  before helpers.connect
  beforeEach ->
    REQUIRED_FIELDS = { 'description', 'name', 'type', 'fileName', expectedAnswer: true }

  it 'should exist', ->
    Question.should.be.ok

  describe '#toJSON', ->
    it 'should hide _id', (done) ->
      Question.create REQUIRED_FIELDS, (err, question) ->
        assert question.toJSON()._id is undefined
        done err

    it 'should hide fileName', (done) ->
      Question.create REQUIRED_FIELDS, (err, question) ->
        assert question.toJSON().fileName is undefined
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

  describe 'answer', ->
    it 'should be the last answer', (done) ->
      fields = _.extend {
        answers: [ { content: 'jama' }, { content: 'tere' } ]
      }, REQUIRED_FIELDS

      Question.create fields, (err, question) ->
        question.answer.content.should.eql 'tere'
        done err

    it 'should be set even if there are no answers', (done) ->
      Question.create REQUIRED_FIELDS, (err, question) ->
        assert question.answer is null
        done err
