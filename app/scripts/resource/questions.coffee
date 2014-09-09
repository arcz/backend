module.exports = questions = angular.module 'testlab.questions', [ 'ngResource' ]

questions.factory 'Question', [ '$resource', ($resource) ->
  $resource '/api/questions', { id: '@id' },
    list:
      method: 'GET'
      isArray: true
      cache: true
]


