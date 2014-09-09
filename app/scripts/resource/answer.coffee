module.exports = questions = angular.module 'testlab.answer', [ 'ngResource' ]

questions.factory 'Answer', [ '$resource', ($resource) ->
  $resource '/api/answer', { id: '@id' },
    get:
      method: 'GET'
      url: '/api/answer/:id'
      cache: false

    save:
      method: 'POST'
      url: '/api/answer/:id'
]


