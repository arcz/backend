"use strict"

bugsnag = require("bugsnag")
bugsnag.register("764cddd764b961bbd41e20c081501ccf")
express = require("express")
http = require("http")
path = require("path")
_ = require("underscore")
mongoose = require("mongoose")
mongoose.connect 'mongodb://localhost/test'
quizConfig = require('./quiz-config')
authConfig = require('./config')

Campfire = require('smores')
campfire = new Campfire(ssl: true, token: authConfig.campfire.apiToken, account: authConfig.campfire.account)

passport = require('passport')
LinkedInStrategy = require('passport-linkedin-oauth2').Strategy
GitHubStrategy = require('passport-github').Strategy

db = mongoose.connection
db.on 'error', console.error.bind console, 'connection error:'
db.once 'open', ->

  env =
    maxDuration: quizConfig.maxDuration

  schemaOptions =
    toObject:
      virtuals: true
    toJSON:
      virtuals: true

  userSchema = mongoose.Schema(
    {
      email: String
      name: String
      avatar: String
      url: String
      authType: String
      startedAt: Date
      durationTook: Number
      finished:
        type: Boolean
        'default': false
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
    }, schemaOptions
  )


  userSchema.methods.checkIfFinished = (cb) ->
    if @durationLeft <= 0 and not @finished
      @finishUser()
      @durationTook = env.maxDuration
      @save cb
    else
      cb null, this

#  userSchema.statics.findByEmail = (email, cb) -> @findOne { email: email }, cb
  userSchema.statics.create = (data) ->
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

  # My personal formula. I think it works the best
  scoreFormula = (answeredRight, answeredWrong, totalRight, totalWrong) ->
    answeredRight/totalRight - answeredWrong/(totalWrong + 1)

  userSchema.methods.finishUser = ->
    @durationTook = env.maxDuration - @durationLeft * 1000
    @finished = true

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
    totalPercent = Math.round ((rightSolutions/@codeAsignIndecies.length) + @result.test.normScore) * 100
    campfire.join authConfig.campfire.roomId, (err, room) =>
      return console.error(err) if err and not room
      room.paste """#{@email} just finished test with following result:
      - test: #{totalRightAnswers} right answers, #{totalWrongAnswers} wrong answers, #{notGivenRightAnswers} not given right answers
      - scores: total score = #{@result.test.totalScore}, normilized score = #{@result.test.normScore}
      - coding: #{rightSolutions} right solutions, #{wrongSolutions} wrong solutions
      - Total percent: #{totalPercent}
      """

  userSchema.virtual('durationLeft').get ->
    res = Math.ceil (env.maxDuration - (Date.now() - @startedAt.getTime())) / 1000
    res = 0 if res < 0
    res

  User = mongoose.model 'User', userSchema

  findOrCreateUser = (cb, userInfo) ->

    User.findOne { $or: [{email: userInfo.email}, {url: userInfo.url}] }, (err, user) ->
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

  passport.use new LinkedInStrategy {
      clientID: authConfig.linkedIn.consumerKey,
      clientSecret: authConfig.linkedIn.consumerSecret
      callbackURL: '/auth/linkedin/callback'
      scope: ['r_emailaddress', 'r_basicprofile']
      profileFields: ['id','picture-url','first-name','last-name','email-address','public-profile-url']
    },
    (accessToken, refreshToken, profile, done) ->
      profile = profile._json
#      console.log 'linkedIn', profile
      findOrCreateUser done,
        email: profile.emailAddress or profile.publicProfileUrl
        avatar: profile.pictureUrl
        url: profile.publicProfileUrl
        name: profile.firstName + ' ' + profile.lastName
        authType: 'linkedin'

  request = require('request')

  passport.use new GitHubStrategy {
    clientID: authConfig.github.appId,
    clientSecret: authConfig.github.appSecret,
    callbackURL: "/auth/github/callback"
    scope: ['user:email']
  },
    (accessToken, refreshToken, profile, done) ->
      profile = profile._json
      cont = ->
        console.log 'findOrCreateUser', profile
        findOrCreateUser done,
          email: profile.email or profile.html_url
          avatar: profile.avatar_url
          url: profile.url
          name: profile.name
          authType: 'github'

      if profile.email
        cont()
      else
        url = "https://api.github.com/user/emails?access_token=#{accessToken}"
        request url, (error, response, body) ->
          if !error && response.statusCode == 200
            emails = JSON.parse(body)
            console.log 'emails:', emails
            for email in emails
              if email.indexOf('noreply.github.com') is -1
                profile.email = email
                break

          return cont()

  passport.serializeUser (user, done) ->
    done null, user.id

  passport.deserializeUser (id, done) ->
    User.findById id, (err, user) ->
      done err, user


  app = express()

  app.configure 'development', ->
    app.use require('connect-livereload')(
      port: 35729
      excludeList: ['/logout', '/auth', '.js', '.css', '.svg', '.ico', '.woff', '.png', '.jpg', '.jpeg']
    )

  app.use express.json()
  app.use express.urlencoded()
  app.use express.cookieParser()
  app.use express.session secret: 'as8df7a76d5f67sd'
  app.configure 'development', ->
    app.use express.static path.resolve __dirname, '../../app'
    app.use express.static path.resolve __dirname, '..'
  app.use passport.initialize()
  app.use passport.session()
  app.set "port", process.env.PORT or 3000

  app.get '/auth/linkedin',
    passport.authenticate('linkedin',
      {scope: ['r_emailaddress', 'r_basicprofile'], state: "blahblah293874kghsd78326"}
      (req, res) ->
    )

  app.get '/auth/github', passport.authenticate 'github'

  app.get '/logout', (req, res) ->
    req.logout()
    res.redirect('/')

#    callbackURL: "http://127.0.0.1:3000/auth/linkedin/callback"

  app.get '/auth/linkedin/callback',
    passport.authenticate 'linkedin', {successRedirect: '/', failureRedirect: '/'}

  app.get '/auth/github/callback',
    passport.authenticate('github', { failureRedirect: '/' }),
    (req, res) ->
      res.redirect('/')

  # simple log
  app.use (req, res, next) ->
    console.log "%s %s", req.method, req.url
    next()

  app.configure 'development', ->
    app.get '/', (req, res) ->
      res.sendfile path.join( __dirname, '../../app/index.html')
#      res.sendfile path.join( __dirname, '../../dist/index.html')

  sendUserJSON = (user, res) ->
    omitFields = ['__v', '_id', 'testIndecies', 'codeAsignIndecies']
    omitFields = omitFields.concat if user.finished
      ['codeSolutions', 'testAnswers']
    else
      ['result']

    userObj = _.omit user.toObject(), omitFields...

    unless user.finished
      userObj.codeSolutions = {}
      for name, solutions of user.codeSolutions
        userObj.codeSolutions[name] = _.last solutions

    res.send JSON.stringify(userObj)

  app.all '/api/user', (req, res, next) ->
    if req.user
      next()
    else
      res.send(403, 'Not logged in')


  app.get "/api/user", (req, res) ->
    user = req.user
    sendUserJSON user, res

  app.put "/api/user", (req, res) ->
    user = req.user
    codeSolutions = req.body?.codeSolutions or {}
    for name, {code:code, pass:pass} of codeSolutions
      lastSolution = _.last user.codeSolutions[name]
      if not lastSolution or lastSolution.code isnt code
        user.codeSolutions[name].push code:code, pass:pass
        user.markModified('codeSolutions')

    testAnswers = req.body?.testAnswers or {}
    for name, answers of testAnswers
      user.testAnswers[name] = answers
      user.markModified 'testAnswers'

    if req.body?.finished and not user.finished
      user.finishUser()

    user.preferedLanguage = req.body?.preferedLanguage

    user.save (err, user) ->
      return res.send 400, err if err
      sendUserJSON user, res

  app.get "/api/env", (req, res) ->
    userEnv = _.clone env
    user = req.user
    if user and not user.finished
      userEnv.testQuestions = user.testIndecies.map (i) -> _.omit quizConfig.testQuestions[i], 'rightAnswers'
      userEnv.codeAssignments = user.codeAsignIndecies.map (i) ->
        question = _.clone quizConfig.codeAssignments[i]
        question.testCase = question.testCase?.toString()
        question
      userEnv.creativeCodeAssignment = quizConfig.creativeCodeAssignment

    res.send userEnv

  # start server
  http.createServer(app).listen app.get("port"), ->
    console.log "Express App started on #{app.get('port')} in #{process.env.NODE_ENV} env"
