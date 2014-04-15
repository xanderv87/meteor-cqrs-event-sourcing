@EventStore = new Meteor.Collection 'events',
  schema: new SimpleSchema(
    executedAt:
      type: Date,
      label: 'Created At'

    name:
      type: String,
      label: 'Event Name'

    eventData:
      type: Object
      blackbox: true
      label: 'Event data'

    executed:
      type: Boolean,
      label: 'Already executed'
    error:
      type: Boolean,
      label: 'Execution resulted in an error'
      optional: true
      defaultValue: false

    errorDetails:
      type: Object
      label: 'Execution error details'
      blackbox: true
      optional: true

  )
@EventStore.allow(
  insert: (userId, doc) ->
    false
  update: (userId, doc, fields, modifier) ->
    false
  remove: (userId, doc) ->
    false
)

if Meteor.isServer

  execute = (id, fields) ->

    handlers = EventHandlers.getEventHandlers fields.name

    _.each(handlers, (handler) ->
      try
        (new handler(fields.eventData)).execute()
        EventStore.update(id, $set: {executed: true})
      catch error
        err = JSON.parse JSON.stringify error
        EventStore.update(id, {$set: {error: true, errorDetails: err}})
    )


  @EventStore.find({executed: false, error: false}, {limit: 1, sort: {executedAt: 1}}).observeChanges
    added: execute
    changed: (id, fields) ->
      if fields.executed
        execute id, fields
