Template.layout.onCreated ()->
  @dataExists = new ReactiveVar false

Template.layout.helpers
  dataExists: ()->
    Session.get 'dataExists' || false
