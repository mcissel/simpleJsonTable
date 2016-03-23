Session.setDefault 'liveQuery', false

Template.extras.events
  'click input[type="radio"]': (event)->
    Session.set 'liveQuery', event.currentTarget.id == "live"

  'click #reset': ()->
    Meteor.call 'reset'
    Session.set 'dataExists', false

Template.extras.helpers
  checkIfStop: ()-> if Session.get 'liveQuery' then '' else 'checked'
  checkIfLive: ()-> if Session.get 'liveQuery' then 'checked' else ''
