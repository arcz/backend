userResource = require '../../resource/user.coffee'

module.exports = profile = angular.module 'testlab.view.profile', [
  userResource.name
  'classy'
  'ui.router'
]

ProfileController = profile.classy.controller
  name: 'ProfileController'
  inject: [
    '$scope'
    '$state'
    'user'
  ]

  init: ->
    @$scope.user = @user

  isAlreadyStarted: (user) ->
    !!user.startedAt

  validateAndStart: (user) ->
    user.$start => @$state.go 'question'

profile.config [ '$stateProvider', ($stateProvider) ->
  $stateProvider.state 'profile',
    url: '/',
    template: require './profile.tpl.html'
    controller: ProfileController
    resolve:
      user: [ 'User', (User) -> User.get() ]
]
