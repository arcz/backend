slack = require '../../server/notifications/slack'

describe 'slack notifications', ->
  it 'should be an fn', ->
    slack.should.be.a.Function
