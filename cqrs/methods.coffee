Meteor.methods(
  executeCommand: (command) ->
    c = Command.createCommand(command)
    c.execute()
)