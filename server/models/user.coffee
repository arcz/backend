mongoose = require 'mongoose'

fields =
  email: String
  name: String
  avatar: String
  url: String
  authType: String
  startedAt: Date
  durationTook: Number
  finished:
    type: Boolean
    default: false
  testIndecies: [Number]
  codeAsignIndecies: [Number]
  codeSolutions: mongoose.Schema.Types.Mixed
  testAnswers: mongoose.Schema.Types.Mixed
  result:
    test:
      totalScore: Number
      normScore: Number
      rightAnswers: Number
      notGivenRightAnswers: Number
      wrongAnswers: Number
    coding:
      rightSolutions: Number
      wrongSolutions: Number
  preferedLanguage:
    type: String
    'enum': ['javascript', 'coffeescript']

module.exports = UserSchema = mongoose.Schema fields,
  toObject: virtuals: true
  toJSON: virtuals: true

UserSchema.statics.create = (data) ->
  data.startedAt = new Date()
  data.testIndecies = _.shuffle([0...quizConfig.testQuestions.length])[...quizConfig.testQuestionsToShow]
  data.codeAsignIndecies = _.shuffle([0...quizConfig.codeAssignments.length])[...quizConfig.codeAssignmentsToShow]

  data.codeSolutions = {}
  for idx in data.codeAsignIndecies
    name = quizConfig.codeAssignments[idx].name
    data.codeSolutions[name] = []
  data.codeSolutions[quizConfig.creativeCodeAssignment.name] = []

  data.testAnswers = {}
  for idx in data.testIndecies
    name = quizConfig.testQuestions[idx].name
    data.testAnswers[name] = []
  new User(data)

UserSchema.statics.findOrCreateUser = (cb, userInfo) ->
  @findOne { $or: [{email: userInfo.email}, {url: userInfo.url}] }, (err, user) ->
    if err or not user
      console.log 'Not found. Creating.'
      user = User.create userInfo
    else
      console.log 'Found. Reading.'
      if user.email isnt userInfo.email
        user.email = userInfo.email
        console.log "Found by url. Rewriting: #{user.url} -> #{user.email}"

    user.save (err, user) ->
      return cb(err) if err
      cb null, user

UserSchema.methods.publicJSON = ->
  omitFields = ['__v', '_id', 'testIndecies', 'codeAsignIndecies']
  omitFields = omitFields.concat if @finished
    ['codeSolutions', 'testAnswers']
  else
    ['result', 'resultPercent']

  userObj = _.omit @toObject(), omitFields...

  unless @finished
    userObj.codeSolutions = {}
    for name, solutions of @codeSolutions
      userObj.codeSolutions[name] = _.last solutions

  JSON.stringify userObj

UserSchema.methods.checkIfFinished = (cb) ->
  if @durationLeft <= 0 and not @finished
    @finishUser()
    @durationTook = env.maxDuration
    @save cb
    return true
  else
    cb null, this
    return false

UserSchema.methods.finishUser = ->
  @durationTook = env.maxDuration - @durationLeft * 1000
  @finished = true

  # My personal formula. I think it works the best
  scoreFormula = (answeredRight, answeredWrong, totalRight, totalWrong) ->
    answeredRight/totalRight - answeredWrong/(totalWrong + 1)

  # Making TEST results
  totalScore = 0
  totalRightAnswers = 0
  totalWrongAnswers = 0
  notGivenRightAnswers = 0
  for idx in @testIndecies

    question = quizConfig.testQuestions[idx]
    name = question.name
    rightAnswersNumber = question.rightAnswers.length
    givenAnswers = @testAnswers[name]
    rightGivenAnswers = _.intersection givenAnswers, question.rightAnswers
    rightGivenAnswersNumber = rightGivenAnswers.length
    rightNotGivenAnswersNumber = rightAnswersNumber - rightGivenAnswersNumber

    [wrongGivenAnswersNumber, wrongAnswersNumber] = if question.cloze
      [rightAnswersNumber - rightGivenAnswersNumber,
       rightAnswersNumber]
    else
      wrongAnswers = _.difference [0...question.options.length], question.rightAnswers
      wrongGivenAnswers = _.intersection givenAnswers, wrongAnswers
      [wrongGivenAnswers.length, wrongAnswers.length]

    score = scoreFormula rightGivenAnswersNumber,
      wrongGivenAnswersNumber,
      rightAnswersNumber,
      wrongAnswersNumber

    totalScore += score
    totalRightAnswers += rightGivenAnswersNumber
    totalWrongAnswers += wrongGivenAnswersNumber
    notGivenRightAnswers += rightNotGivenAnswersNumber
    score = rightGivenAnswersNumber = wrongGivenAnswersNumber = rightNotGivenAnswersNumber = 0

  @result.test =
    totalScore: totalScore
    normScore: totalScore / @testIndecies.length #Normilized (Average) score. From -xx to 1
    rightAnswers: totalRightAnswers
    wrongAnswers: totalWrongAnswers
    notGivenRightAnswers: notGivenRightAnswers

  #make Coding result
  rightSolutions = 0
  for idx in @codeAsignIndecies
    codeAssignment = quizConfig.codeAssignments[idx]
    name = codeAssignment.name
    goodSolution = _.findWhere @codeSolutions[name], pass: true
    rightSolutions += 1 if goodSolution
  wrongSolutions = @codeAsignIndecies.length - rightSolutions

  @result.coding =
    rightSolutions: rightSolutions
    wrongSolutions: wrongSolutions

  @markModified('result')
  totalPercent = Math.round ((rightSolutions/@codeAsignIndecies.length) + @result.test.normScore) * 100/2

#   campfire?.join authConfig.campfire.roomId, (err, room) =>
#     return console.error(err) if err and not room
#     room.paste """#{@name} (#{@email}) just finished test with #{totalPercent}% of success. Details:
#                   - test: #{totalRightAnswers} right answers, #{totalWrongAnswers} wrong answers, #{notGivenRightAnswers} not given right answers
#                   - coding: #{rightSolutions} right solutions, #{wrongSolutions} wrong solutions
#                """

UserSchema.virtual('resultPercent').get ->
  Math.round ((@result.coding.rightSolutions/@codeAsignIndecies.length) + @result.test.normScore) * 100/2

UserSchema.virtual('durationLeft').get ->
  res = Math.ceil (env.maxDuration - (Date.now() - @startedAt.getTime())) / 1000
  res = 0 if res < 0
  res

UserSchema.virtual('isAdmin').get -> @email in authConfig.admins
