sortQuestion = require '../../scripts/lib/sort-question.coffee'

describe 'sort questions', ->
  it 'should exist', ->
    sortQuestion.should.be.ok

  it 'should return an array', ->
    res = sortQuestion []
    res.should.be.an.Array

  it 'should not throw when no questions is defined', ->
    (-> sortQuestion null).should.not.throw()

  it 'should sort the questions by group', ->
    questions = [
      { name: 2, group: 'a' },
      { name: 1, group: 'b' }
    ]
    res = sortQuestion questions, [ 'b', 'a' ]
    res[0].name.should.eql 1

  it 'should sort undefined groups as last', ->
    questions = [
      { name: 2, group: 'a' },
      { name: 1, group: 'b' }
    ]
    res = sortQuestion questions, [ 'b' ]
    res[0].name.should.eql 1

  it 'should sort by group name if no group is defined', ->
    questions = [
      { name: 2, group: 'b' },
      { name: 3, group: 'c' }
      { name: 1, group: 'a' }
    ]
    res = sortQuestion questions
    res[0].name.should.eql 1
    res[1].name.should.eql 2
    res[2].name.should.eql 3

