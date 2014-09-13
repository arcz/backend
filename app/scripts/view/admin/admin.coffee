adminResource = require '../../resource/admin.coffee'

module.exports = admin = angular.module 'testlab.view.admin', [
  adminResource.name
  'classy'
  'ui.router'
]

AdminController = admin.classy.controller
  inject: [
    '$scope'
    'users'
  ]

  init: ->
    @$scope.users = @users


admin.config [ '$stateProvider', ($stateProvider) ->
  $stateProvider.state 'admin',
    url: '/admin'
    template: require './admin.tpl.html'
    controller: AdminController
    resolve:
      users: [ 'Admin', (Admin) -> Admin.users().$promise ]
]

