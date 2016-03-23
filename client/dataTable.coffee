docsPerPage = 5 # this isn't changing

Template.dataTable.onCreated ()->
  Session.set 'pageName', 'Data Table'

  @currentPage = new ReactiveVar 1
  @previousPage = 1
  @totalPageCount = new ReactiveVar 1
  @updateUI = new ReactiveVar false

  #
  @subscriptionHandle = {}
  @staticTableData = []

  # Populate the one-time reactive 'totalPageCount' variable
  Meteor.call 'getTotalJSONDataCount', (error, result)=>
    unless error
      @totalPageCount.set Math.ceil( result/docsPerPage )

  # Function to retrieve a reactive data cursor
  @jsonData = ()->
    sort = Session.get 'sort'

    if sort?.field? && (sort.direction == -1 || sort.direction == 1)
      cursor = JSONData.find {}, {sort: {"#{sort.field}": sort.direction}}
    else
      cursor = JSONData.find {}


Template.dataTable.onRendered ()->
  @autorun ()=>
    unless Session.get 'liveQuery'
      @subscriptionHandle.stop?()

    newPage = thisPage()
    @subscriptionHandle = @subscribe 'jsonData',
      newPage
      Session.get 'sort'
      ()=>
        @previousPage = newPage
        Meteor.setTimeout ()=>
          unless Session.get 'liveQuery'
            @staticTableData = @jsonData().fetch()
            @updateUI.set true
        , 0

Template.dataTable.events
  'click #prevPage': ()->
    currentPage = thisPage()
    if currentPage > 1
      Template.instance().currentPage.set currentPage - 1

  'click #nextPage': ()->
    currentPage = thisPage()
    if currentPage < lastPage()
      Template.instance().currentPage.set currentPage + 1

  'click th': ()->
    sort = Session.get 'sort'

    if sort?.field == @field
      direction = -1 * sort.direction
    else
      direction = 1

    Session.set 'sort', {field: @field, direction: direction}


Template.dataTable.helpers
  tableHeaders: ()->    JSONDataFields.find().fetch()
  currentPage: ()->     thisPage()
  totalPageCount: ()->  lastPage()
  previousPage: ()->    Template.instance().previousPage

  tableData: ()->
    ti = Template.instance()

    if Session.get 'liveQuery'
      ti.jsonData()
    else
      update = ti.updateUI.get() # this is reactive
      if update
        ti.updateUI.set false
      else
        ti.staticTableData # this is not reactive

  prevPageClass: ()-> if thisPage() <= 1 then 'disabled' else ''
  nextPageClass: ()-> if thisPage() == lastPage() then 'disabled' else ''

  getValue: (doc, field)->
    if (field.toLowerCase() == 'date')
      moment(new Date(doc[field])).format "MMM D, 'YY, h:mm a"
    else
      doc[field]

  sortArrow: (field)->
    sort = Session.get 'sort'
    if sort?.field == field
      if sort.direction == -1 then '-desc' else '-asc'
    else
      ''

thisPage = ()-> Template.instance().currentPage.get()
lastPage = ()-> Template.instance().totalPageCount.get()
