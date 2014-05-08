Template.addElement.events
  'click #openElementButtonContainer': -> openElementsContainer()
  'click #openDateTimeElementsContainer': -> openDateTimeElementsContainer()
  'click [data-action="addElement"]': (e) ->
    parentId = @itinerary._id if @itinerary?
    parentId = @card._id if @card?
    if parentId?
      elementId = Elements.insert
        type: e.target.getAttribute('data-element-type')
        parent_id: parentId
      $("div[data-element-id='#{elementId}'] input").focus()
      showOpeners()
