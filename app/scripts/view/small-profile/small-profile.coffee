userResource = require '../../resource/user.coffee'

module.exports = smallProfile = angular.module 'testlab.view.smallprofile', [
  userResource.name
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
      @User.get (user) =>
        @$scope.user = user
