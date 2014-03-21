Package.describe({
    summary: "CQRS with event-sourcing package."
});

Package.on_use(function (api) {
    api.use('underscore', 'client');
    api.use('coffeescript', ['client', 'server']);
    api.use('collection2', ['client', 'server']);
    api.imply && api.imply('collection2', ['client', 'server']);


   api.add_files('collections/events.coffee', ['client', 'server']);
   api.add_files('cqrs/Command.coffee', ['client', 'server']);
   api.add_files('cqrs/EventHandler.coffee', ['client', 'server']);
   api.add_files('cqrs/methods.coffee', ['server']);
});