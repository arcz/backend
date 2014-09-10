User = require '../../resource/user.coffee'

module.exports = login = angular.module 'testlab.view.login', [
  User.name
  'ui.router'
]

login.config [ '$stateProvider', ($stateProvider) ->
  $stateProvider.state 'login',
    url: '/login',
    template: require './login.tpl.html'
    resolve: [ 'User', '$q', (User, $q) ->
      deffered = $q.defer()
      # If we have the state then do not allow showing the login page
      User.get deffered.reject, deffered.resolve
      deffered.promise
    ]
]

