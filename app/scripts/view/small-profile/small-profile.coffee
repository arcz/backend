state = require '../../state.coffee'

module.exports = smallProfile = angular.module 'lobzik.view.smallprofile', [
  'classy'
  state.name
]

smallProfile.directive 'smallProfile', ->
  template: require './small-profile.tpl.html'
  controller: smallProfile.classy.controller
    inject: [
      '$scope'
      'state'
    ]

    init: ->
      @getUser()

    getUser: ->
      @state.get().then (user) =>
        @$scope.user = user
