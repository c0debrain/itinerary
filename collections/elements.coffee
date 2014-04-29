@Elements = new Meteor.Collection 'elements',
  transform: (doc) ->
    switch doc.type
      when 'title'
        return new TitleElement(doc)
      when 'description'
        return new DescriptionElement(doc)
      when 'divider'
        return new DividerElement(doc)
      when 'photo'
        return new PhotoElement(doc)
      when 'text'
        return new TextElement(doc)
      when 'link'
        return new LinkElement(doc)
      when 'date'
        return new DateElement(doc)
      when 'map'
        return new MapElement(doc)
    doc

@Elements.before.insert (userId, doc) ->
  highestElement = Elements.findOne({ parentId: doc.parentId },
                     sort: { position: -1 }
                     limit: 1
                   )
  position = if highestElement? then highestElement.position() else 0
  doc.position = position + 1

@createElement = (attributes) ->
  typeWhitelist =
    title: true
    description: true
    divider: true
    text: true
    link: true
    photo: true
    map: true
    date: true

  throw new Meteor.Error(422, 'Element type needs to be declared') unless attributes.type
  throw new Meteor.Error(422, 'Element type needs a parent') unless attributes.parentId
  throw new Meteor.Error(422, 'Element type needs to be valid') unless attributes.type of typeWhitelist

  switch attributes.type
    when 'title'
      attributes.body = 'Itinerary title'
    when 'description'
      attributes.body = 'A short description'
    when 'text'
      attributes.body = 'Add some text'
    when 'link'
      attributes.body = 'Link the interwebs'
    when 'photo'
      attributes.body = 'Link a photo'
    when 'map'
      attributes.body = 'Enter an address'
    when 'date'
      attributes.body = 'Specify a date or time'

  attributes.editable = true
  Elements.insert(attributes)

@updateElement = (elementId, type, body) ->
  attributes = { editable: false }
  switch type
    when 'link'
      markdownLink = /\[([^\]]+)\]\(([^)]+)\)/.exec(body)
      if markdownLink
        attributes.body = markdownLink[2]
        attributes.second_body = markdownLink[1]
      else
        attributes.body = body
        attributes.second_body = 'A link to the interwebs'
    when 'date'
      if body.match(/\d{4}-\d{2}-\d{2}/)
        attributes.body = body.split('-').reverse().join('/')
      else
        attributes.body = body
    else
      attributes.body = body
  Elements.update({ _id: elementId }, { $set: attributes })

Meteor.methods
  deleteElement: (elementId) ->
    Elements.remove(elementId)
