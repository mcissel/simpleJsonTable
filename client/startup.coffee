Meteor.subscribe 'jsonDataFields'

Meteor.startup () ->
  Meteor.autorun () ->
    document.title = "Simple JSON Table - " + Session.get 'pageName'


  sAlert.config
    effect: 'slide'
    position: 'top'
    timeout: 5000
    html: false
    onRouteClose: true
    stack:
      spacing: 10
      limit: 2
    offset: 0
    beep: false,
#    examples:
#    beep: '/beep.mp3'  // or you can pass an object:
#    beep: {
#        info: '/beep-info.mp3',
#        error: '/beep-error.mp3',
#        success: '/beep-success.mp3',
#        warning: '/beep-warning.mp3'
#    }
    onClose: _.noop
#    examples:
#    onClose: function() {
#        /* Code here will be executed once the alert closes. */
#    }
