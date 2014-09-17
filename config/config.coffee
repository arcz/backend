path = require 'path'

module.exports =
  frontend: path.resolve __dirname, '../../test-lab-frontend/dist'

  # Some random unique string. Used by express
  sessionKey : 'blahbahblah'
  admins     : ['mikk@kolmas.org']
