User = require '../../resource/user.coffee'

module.exports = smallProfile = angular.module 'testlab.view.smallprofile', [
  User.name
  'classy'
]

smallProfile.directive 'smallProfile', ->
  template: require './small-profile.tpl.html'
  controller: smallProfile.classy.controller
    inject: [
      '$scope'
      'User'
    ]

    init: ->
      @User.get().$promise.then (user) =>
        @$scope.user = user
