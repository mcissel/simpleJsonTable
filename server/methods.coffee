Meteor.methods
  reset: ()->
    JSONData.remove({})
    JSONDataFields.remove({})

  getTotalJSONDataCount: ()->
    JSONData.find().count()

  parseJSON: (data)->
    try
      json = JSON.parse data
    catch error
      throw new Meteor.Error(error, "invalid-json", "The uploaded file must be a valid JSON format.")

    # The JSON file can be a JSON array or a JSON object
    unless Array.isArray json
      for key,value of json
        if json.hasOwnProperty(key) and Array.isArray(value)
          name = key
          json = value
          break


    # Throw an error if no valid array is found
    unless Array.isArray json
      throw new Meteor.Error("no-valid-data", "The collection must be in the 0th or 1st level of the uploaded JSON formatted file.")
      return

    JSONData.remove({})
    JSONDataFields.remove({})

    fields = _.chain(json)
      .map (doc)-> _.keys(doc)
      .flatten()
      .uniq()
      .each (field)->
        JSONDataFields.insert {field:field}

    # The newly added ids are returned to the client
    newIds = for doc in json
      JSONData.insert doc
