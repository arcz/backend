mongoose = require 'mongoose'

require '../../../server/models/answer'
Answer = mongoose.model 'Answer'

describe 'Answer model', ->
  it 'should exist', ->
    Answer.should.be.ok
