module.exports = user = angular.module 'testlab.user', [ 'ngResource' ]

user.factory 'User', [ '$resource', ($resource) ->
  $resource '/api/user', { }, {
    start:
      method: 'PUT'
      url: '/api/user/start'
  }
]
