@JSONData = new Mongo.Collection 'jsonData'
@JSONDataFields = new Mongo.Collection 'jsonDataFields'

Meteor.publish 'jsonDataFields', ()->
  JSONDataFields.find({})

Meteor.publish 'jsonData', (page, sort) ->
  Meteor._sleepForMs(2000)
  projection =
    limit: 5
    skip: (page - 1) * 5

  console.log sort

  if sort?.field? && (sort.direction == -1 || sort.direction == 1)
    projection.sort = {"#{sort.field}": sort.direction}

  JSONData.find {}, projection
