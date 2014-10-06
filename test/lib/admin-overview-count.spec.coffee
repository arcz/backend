_ = require 'lodash'

adminViewCount = require '../../lib/admin-overview-count'

describe 'admin view count', ->
  it 'should return obj', ->
    _.isPlainObject(adminViewCount []).should.be.ok

  it 'should return total count', ->
    adminViewCount([{}]).total.should.eql 1

  it 'should return finished count', ->
    adminViewCount([{}]).finished.should.eql 0

  it 'should return finished count by finishedAt', ->
    adminViewCount([ finishedAt: Date.now() ]).finished.should.eql 1

  it 'should return running count by if there is one finished ones', ->
    data = [
      { finishedAt: Date.now() }
      {}
    ]
    adminViewCount(data).running.should.eql 1

  it 'should return running count if there are all finished', ->
    data = [
      { finishedAt: Date.now() }
      { finishedAt: Date.now() }
    ]
    adminViewCount(data).running.should.eql 0
