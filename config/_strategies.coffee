module.exports =
  github:
    clientID: 'client-id'
    clientSecret: 'client-secret'
    callbackURL: '/auth/github/callback'
    scope: ['user:email']

  linkedIn:
    clientID: 'client-id'
    clientSecret: 'client-secret'
    callbackURL: '/auth/linkedin/callback'
    scope: [
      'r_emailaddress',
      'r_basicprofile'
    ]
    profileFields: [
      'id',
      'picture-url',
      'first-name',
      'last-name',
      'email-address',
      'public-profile-url'
    ]
    # A long unique string value of your choice that is hard to guess.
    # Used to prevent CSRF.
    state: 'blahblah'

  facebook:
    clientID: 'client-id'
    clientSecret: 'client-secret'
    callbackURL  : '/auth/facebook/callback'
    profileFields: ['email', 'first_name', 'last_name', 'link', 'id']

  google:
    clientID: 'client-id'
    clientSecret: 'client-secret'
    callbackURL: 'http://localhost:3000/auth/google/callback'

