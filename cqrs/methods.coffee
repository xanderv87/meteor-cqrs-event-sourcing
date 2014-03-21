Meteor.methods(
  executeCommand: (command) ->
    c = Commands.createCommand(command)
    c.execute()
)