class @EventHandler
  constructor: (@data) ->
    if Meteor.isServer
      @user = this.userId
    else
      @user = Meteor.userId()
    @eventName = @.constructor.name



class @EventHandlers
  @eventHandlers: {}
  @validateEventHandler = (eventHandler) ->
    if eventHandler.prototype.execute instanceof Function
      true
    else
      throw new Meteor.Error "EventHandler: "+ eventHandler.prototype.constructor.name + " does not has an execute function"

  @register: (commandName, eventHandler) ->
    @validateEventHandler eventHandler
    if not @eventHandlers[commandName]
      @eventHandlers[commandName] = []
    @eventHandlers[commandName].push(eventHandler)

  @getEventHandlers: (commandName) ->
    @eventHandlers[commandName] or []


