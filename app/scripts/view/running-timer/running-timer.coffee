moment = require 'moment'
user   = require '../../resource/user.coffee'

module.exports = runningTimer = angular.module 'testlab.view.runningtimer', [
  user.name
  'classy'
]

formatMs = (ms) ->
  moment(ms).format 'mm:ss'

toMin = (ms) ->
  ms / 60 / 1000

runningTimer.directive 'runningTimer', ->
  template: require './running-timer.tpl.html'
  controller: runningTimer.classy.controller
    inject: [
      '$scope'
      '$timeout'
      'User'
    ]

    init: ->
      @User.get (user) =>
        @$scope.user     = user
        @$scope.timeLeft = user.timeLeft
        @updateRunningTimer() if @isStarted

    isStarted: ->
      return @$scope.user?.isStarted

    updateRunningTimer: ->
      return if @$scope.timeLeft <= 0
      @$scope.timeLeft -= 1000
      @$timeout @updateRunningTimer, 1000

    getFormattedTotal: (time) ->
      return unless @isStarted()
      formatMs time

    getFormattedDuration: (total, left) ->
      return unless @isStarted()
      formatMs total - left

    isCritical: (ms) ->
      toMin(ms) <= 2

    isWarning: (ms) ->
      toMin(ms) <= 8
