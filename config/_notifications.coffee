module.exports =
  slack:
    config:
      domain: 'toggl'
      token: 'token'
    triggers:
      finish: (user) ->
        text: "#{user.name} finished test."
        channel: '#toggl-web'
        username: 'Bot'
