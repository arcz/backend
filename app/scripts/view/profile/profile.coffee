state = require '../../state.coffee'

module.exports = profile = angular.module 'testlab.view.profile', [
  state.name
  'classy'
  'ngRoute'
]

ProfileController = profile.classy.controller
  name: 'ProfileController'
  inject: [
    '$scope'
    '$location'
    'state'
  ]

  init: ->
    @state.get().then (user) =>
      @$scope.user = user

  isAlreadyStarted: (user) ->
    !!user.startedAt

  validateAndStart: (user) ->
    user.$start =>
      @$location.path '/questions'

profile.config [ '$routeProvider', ($routeProvider) ->
  $routeProvider.when '/',
    template: require './profile.tpl.html'
    controller: ProfileController
    resolve: [ 'state', (state) -> state.get() ]
]
