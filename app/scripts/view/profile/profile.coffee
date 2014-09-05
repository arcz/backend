User = require '../../resource/user.coffee'

module.exports = profile = angular.module 'testlab.view.profile', [
  User.name
  'classy'
  'ui.router'
]

ProfileController = profile.classy.controller
  name: 'ProfileController'
  inject: [
    '$scope'
    '$location'
    'User'
  ]

  init: ->
    @$scope.user = @User.get()

  isAlreadyStarted: (user) ->
    !!user.startedAt

  validateAndStart: (user) ->
    user.$start =>
      @$location.path '/questions'

profile.config [ '$stateProvider', ($stateProvider) ->
  $stateProvider.state 'profile',
    url: '/',
    template: require './profile.tpl.html'
    controller: ProfileController
    resolve: [ 'User', (User) -> User.get() ]
]
