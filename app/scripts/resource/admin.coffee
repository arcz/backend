module.exports = admin = angular.module 'testlab.admin', [ 'ngResource' ]

admin.factory 'Admin', [ '$resource', ($resource) ->
  $resource '/api/admin', { },
    users:
      isArray: true
      url: '/api/admin/users'
      cache: false
]
