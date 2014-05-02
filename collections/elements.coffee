@Elements = new Meteor.Collection 'elements',
  transform: (doc) ->
    switch doc.type
      when 'title'
        _.extend(new Element(doc), Element.prototype, TitleElement.prototype)
      when 'description'
        _.extend(new Element(doc), Element.prototype, DescriptionElement.prototype)
      when 'datetime-local'
        _.extend(new Element(doc), Element.prototype, DateTimeElement.prototype)
      when 'divider'
        _.extend(new Element(doc), Element.prototype, DividerElement.prototype)
      when 'photo'
        _.extend(new Element(doc), Element.prototype, PhotoElement.prototype)
      when 'text'
        _.extend(new Element(doc), Element.prototype, TextElement.prototype)
      when 'link'
        _.extend(new Element(doc), Element.prototype, LinkElement.prototype)
      when 'date'
        _.extend(new Element(doc), Element.prototype, DateTimeElement.prototype)
      when 'time'
        _.extend(new Element(doc), Element.prototype, DateTimeElement.prototype)
      when 'card'
        _.extend(new Element(doc), Element.prototype, CardElement.prototype)
      when 'map'
        _.extend(new Element(doc), Element.prototype, MapElement.prototype)
    doc

@Elements.before.insert (userId, doc) ->
  highestElement = Elements.findOne({ parentId: doc.parentId },
                     sort: { position: -1 }
                     limit: 1
                   )
  position = if highestElement? then highestElement.position else 0
  doc.position = position + 1

@createElement = (attributes) ->
  throw new Meteor.Error(422, 'Element needs a parent') unless attributes.parentId
  throw new Meteor.Error(422, 'Element type needs to be declared') unless attributes.type
  throw new Meteor.Error(422, 'Element type needs to be valid') unless _.contains(defaults.element.types, attributes.type)
  attributes.body = defaults.element[attributes.type] unless attributes.body?
  attributes.editable = true
  Elements.insert(attributes)

@createHeaderElements = (parentId, parent) ->
  createElement
    type: 'title'
    body: parent.title
    parentId: parentId
    belongsTo: 'itinerary'
    headerElement: true
  createElement
    type: 'description'
    parentId: parentId
    belongsTo: 'itinerary'
    headerElement: true

@updateElement = (id, type, body) ->
  attributes = { editable: false }
  attributes.original_body = body if type is 'photo' or 'link'
  switch type
    when 'link'
      markdownLink = /\[([^\]]+)\]\(([^)]+)\)/.exec(body)
      if markdownLink
        attributes.body = markdownLink[2]
        attributes.second_body = markdownLink[1]
      else
        attributes.body = body
        attributes.second_body = 'A link to the interwebs'
    when 'datetime-local'
      if body.match(/\d{4}-\d{2}-\d{2}T\d{2}:\d{2}(:\d{2})?/)
        attributes.body = body.split('T').join(" at ")
      else
        attributes.body = body
    when 'date'
      if body.match(/\d{4}-\d{2}-\d{2}/)
        attributes.body = body.split('-').reverse().join('/')
      else
        attributes.body = body
    else
      attributes.body = body
  Elements.update({ _id: id }, { $set: attributes })

Meteor.methods
  deleteElement: (id) ->
    Elements.remove(id)
