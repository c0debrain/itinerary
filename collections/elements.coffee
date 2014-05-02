@Elements = new Meteor.Collection 'elements',
  transform: (doc) ->
    _.extend(new Element(doc), Element.prototype, defaults.element[doc.type].prototype)

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
  attributes.body = defaults.element[attributes.type].body unless attributes.body?
  attributes.editable = true
  Elements.insert(attributes)

@createHeaderElements = (parentId, parent) ->
  createElement
    type: 'title'
    body: parent.title
    parentId: parentId
    belongsTo: parent.type
    headerElement: true
  createElement
    type: 'description'
    parentId: parentId
    belongsTo: parent.type
    headerElement: true

@resetHeaderElements = (parentId, parent) ->
  Elements.update { parentId: parentId, type: 'title' },
    $set:
      body: parent.title
      editable: true
  Elements.update { parentId: parentId, type: 'description' },
    $set:
      body: defaults.element.description.body
      editable: true

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
  deleteElement: (id) -> Elements.remove(id)
