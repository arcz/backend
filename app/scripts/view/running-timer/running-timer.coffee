moment = require 'moment'
state  = require '../../state.coffee'

module.exports = runningTimer = angular.module 'testlab.view.runningtimer', [
  'classy'
  state.name
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
      'state'
    ]

    init: ->
      @state.get().then (user) =>
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


