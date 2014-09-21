Slack = require 'node-slack'

# When called creates a new slack client with a given config
# then exposes the client send method to user
module.exports = ({ domain, token } = {}) ->
  client = new Slack domain, token
  -> client.send arguments...

