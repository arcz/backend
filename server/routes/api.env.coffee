_          = require 'lodash'
quizConfig = require '../../config/quiz'

module.exports = (app) ->
  app.get "/api/env", (req, res) ->
    userEnv = {}
    user = req.user
    if user?.isAdmin
      userEnv = _.clone quizConfig
      userEnv.codeAssignments.forEach (codeTest) ->
        codeTest.testCase = codeTest.testCase?.toString()
      res.send userEnv
      return

    if user and not user.finished
      userEnv.testQuestions = user.testIndecies.map (i) -> _.omit quizConfig.testQuestions[i], 'rightAnswers'
      userEnv.codeAssignments = user.codeAsignIndecies.map (i) ->
        question = _.clone quizConfig.codeAssignments[i]
        question.testCase = question.testCase?.toString()
        question
      userEnv.creativeCodeAssignment = quizConfig.creativeCodeAssignment

    res.send userEnv

