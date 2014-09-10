_            = require 'lodash'
user         = require '../../resource/user.coffee'
runningtimer = require '../../view/running-timer/running-timer.coffee'

module.exports = breadcrumb = angular.module 'testlab.view.breadcrumb', [
  user.name
  runningtimer.name
  'classy'
  'ui.router'
]

breadcrumb.directive 'breadcrumb', ->
  template: require './breadcrumb.tpl.html'
  controller: breadcrumb.classy.controller
    inject: [
      '$scope'
      '$state'
      'User'
    ]

    init: ->
      @User.get (user) =>
        @$scope.user = user

    navigate: (state) ->
      @$state.go state

    isActive: (names...) ->
      _.any names, (name) =>
        @$state.current.name is name

    isStarted: (user) ->
      user?.startedAt

    isFinished: (user) ->
      user?.finishedAt
