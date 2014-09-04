state = require '../../state.coffee'

module.exports = smallprofile = angular.module 'lobzik.view.smallprofile', [ state.name ]

class SmallProfileController
  constructor: (@$scope, @state) ->
    @getUser()

  getUser: =>
    @state.get().then (user) =>
      @$scope.user = user

smallprofile.directive 'smallProfile', ->
  template: require './small-profile.tpl.html'
  controller: [ '$scope', 'state', SmallProfileController ]
