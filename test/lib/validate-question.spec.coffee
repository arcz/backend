validateQuestion = require '../../lib/validate-question'

describe 'validate-question', ->
  it 'should return false if falsy value is given', ->
    validateQuestion(null).should.not.be.ok
    validateQuestion(false).should.not.be.ok
    validateQuestion(undefined).should.not.be.ok
    validateQuestion('').should.not.be.ok

  it 'should return false if question has null or undefined name', ->
    validateQuestion({ 'name': null }).should.not.be.ok
    validateQuestion({ 'name': undefined }).should.not.be.ok

  it 'should return false if no type is given', ->
    validateQuestion({'description', 'name'}).should.not.be.ok

  it 'should return true if all valid fields are available', ->
    validateQuestion({ 'name', 'description', 'type' }).should.be.ok
