state = require '../../state.coffee'

module.exports = questions = angular.module 'lobzik.view.questions', [ state.name ]

questions.config [ '$routeProvider', ($routeProvider) ->
  $routeProvider.when '/questions/',
    template: require './questions.tpl.html'
]
