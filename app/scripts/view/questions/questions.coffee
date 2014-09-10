userResource     = require '../../resource/user.coffee'
questionResource = require '../../resource/questions.coffee'
questionView     = require './question.coffee'

_ = require 'lodash'

module.exports = questions = angular.module 'testlab.view.questions', [
  userResource.name
  questionResource.name
  questionView.name
  'classy'
  'ui.router'
]

questions.config [ '$stateProvider', ($stateProvider) ->
  $stateProvider.state 'question',
      url: '/question'
      template: require './questions.tpl.html'
      controller: QuestionsController
      resolve:
        questions: [ 'Question', (Question) -> Question.list().$promise ]
        user: [ 'User', (User) -> User.get().$promise ]
]

QuestionsController = questions.classy.controller
  inject: [
    '$scope'
    '$state'
    'questions'
    'user'
  ]

  init: ->
    @$scope.questions = @questions
    @$state.go 'question.id', id: _.first(@questions).id

  isLastQuestion: ->
    id = @$state.params.id
    index = _.findIndex @questions, { id }
    index is @questions.length - 1

  finish: ->
    @user.$finish()


