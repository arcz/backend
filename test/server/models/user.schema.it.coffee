helpers = require '../../test-helpers'
clearDB = require('mocha-mongoose') helpers.dbURL

User = require '../../../server/models/user'

describe 'User schema', ->
  before (done) ->
    helpers.connect done

  describe 'validations', ->
    it 'should not create a user without email', (done) ->
      User.create { 'name' }, (err, user) ->
        done user

    it 'should not create a user without name', (done) ->
      User.create { 'email' }, (err, user) ->
        done user

  it 'should set startedAt as date', (done) ->
    User.create { 'email', 'name' }, (err, user) ->
      user.startedAt.should.be.instanceof Date
      done err
