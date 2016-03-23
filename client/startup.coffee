Meteor.subscribe 'jsonDataFields'

Meteor.startup () ->
  Meteor.autorun () ->
    console.log 'running page name change'
    document.title = "Simple JSON Table - " + Session.get 'pageName'
