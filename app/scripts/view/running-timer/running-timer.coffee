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

    watch:
      'user': 'updateRunningTimer'

    init: ->
      @User.get (user) =>
        @$scope.user = user

    isStarted: ->
      @$scope.user?.isStarted

    isFinished: ->
      @$scope.user?.finishedAt

    updateRunningTimer: ->
      return if @timerId
      return if @isFinished()
      return unless @$scope.user?.timeLeft?
      return unless @isStarted()
      @$scope.user.timeLeft -= 1000
      @timerId = @$timeout =>
        @timerId = null
        @updateRunningTimer()
      , 1000

    getFormattedTotal: (time) ->
      return unless @isStarted()
      formatMs time

    getFormattedDuration: (total, left) ->
      return unless @isStarted()
      time = total - left
      formatMs time or 0

    isCritical: (ms) ->
      toMin(ms) <= 2

    isWarning: (ms) ->
      toMin(ms) <= 8
