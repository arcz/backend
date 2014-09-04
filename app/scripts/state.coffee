user = require './user.coffee'

module.exports = state = angular.module 'lobzik.state', [ user.name ]

class State
  constructor: (@User, @$q) ->

  pull: ->
    @deffered = @$q.defer()
    @User.get().$promise.then @deffered.resolve, @deffered.reject
    @deffered.promise

  get: ->
    return @deffered.promise if @deffered
    @pull()

state.service 'state', [ 'User', '$q', State ]

