@JSONData = new Mongo.Collection 'jsonData'
@JSONDataFields = new Mongo.Collection 'jsonDataFields'

Meteor.subscribe 'jsonDataFields'
