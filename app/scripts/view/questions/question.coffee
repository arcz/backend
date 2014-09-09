templates = require './templates/index.coffee'
Question  = require '../../resource/questions.coffee'

_ = require 'lodash'

module.exports = question = angular.module 'testlab.view.question', [
  Question.name
  templates.name
  'classy'
  'ui.router'
]

questionResolve = (Question, $q, $stateParams) ->
  deffered = $q.defer()
  id       = $stateParams.id
  return deffered.reject() unless id
  successCb = (questions) ->
    question = _.find questions, { id }
    if question
      deffered.resolve question
    else
      deffered.reject()
  Question.list().$promise.then successCb, deffered.reject
  deffered.promise

question.config [ '$stateProvider', ($stateProvider) ->
  $stateProvider.state 'question.id',
      url: '/:id',
      template: require './question.tpl.html'
      controller: QuestionController
      resolve:
        question: [ 'Question', '$q', '$stateParams', questionResolve ]
]

QuestionController = question.classy.controller
  inject: [
    '$scope'
    'question'
  ]

  init: ->
    @$scope.question = @question
    @$scope.answer   = {}

  submitAnswer: (question, answer) ->
    question.$answer answer
