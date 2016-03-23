Template.upload.onCreated ()->
  Session.set 'pageName', 'Upload File'

Template.upload.events
  'click [name="uploadFile"]': (event, template)->
    event.target.value = ""

  'change [name="uploadFile"]': (event, template)->
    reader = new FileReader()
    reader.onload = (readerEvent)->
      window.data = readerEvent.target.result
      Meteor.call 'parseJSON', readerEvent.target.result, (error, result) ->
        if error
          console.log error
        else
          console.log result
          Session.set 'dataExists', true

    reader.readAsText event.target.files[0]
