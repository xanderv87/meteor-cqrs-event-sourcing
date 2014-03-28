class @Command

  constructor: (@data) ->
    @user = ""
    if Meteor.isServer
      @user = this.userId
    else
      @user = Meteor.userId()
    @commandName = @.constructor.name

  insertEvent: (name) ->
    EventStore.insert
      executedAt: new Date
      name: name
      eventData: @data
      executed: false


# static part
class @Commands
  @commands = {}
  @validateCommand = (command) ->
    if command.prototype.execute instanceof Function
      true
    else
      throw new Meteor.Error "Command: "+ command.prototype.constructor.name + " does not has an execute function"


  @register = (name, command) ->
    @validateCommand command
    @commands[name] = command


  @createCommand = (command) ->
    _.extend(new @commands[command.commandName](), command)

