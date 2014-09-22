envConfig  = require '../../config/env'
quizConfig = require '../../config/quiz'

buildConf = (env, quiz) ->
  env.duration = quiz.duration
  env

module.exports = (app) ->
  app.get '/env', (req, res) ->
    res.send buildConf envConfig, quizConfig
