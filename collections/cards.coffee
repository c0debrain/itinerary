@Cards = new Meteor.Collection('cards')

@createCard = (attributes) ->
  console.log(createCard)
  typeWhitelist =
    accommodation: true
    travel: true
    event: true
  throw new Meteor.Error(422, 'Element needs a parent') unless attributes.parentId
  throw new Meteor.Error(422, 'Element type needs to be declared') unless attributes.type
  throw new Meteor.Error(422, 'Element type needs to be valid') unless attributes.type of typeWhitelist
  cardId = Cards.insert({})
  createElement
    type: 'title'
    body: defaults.card.title
    parentId: cardId
    headerElement: true
  createElement
    type: 'description'
    parentId: cardId
    headerElement: true
  attributes.elementId = createElement
    type: 'card'
    body: cardId
    parentId: attributes.parentId
    cardType: attributes.type
    cardTitle: defaults.card.title
    cardDescription: defaults.element.description
  Cards.update(cardId, attributes)
  cardId

@updateCardType = (id, type) ->
  console.log('updateCardType')
  console.log(id, type)

Meteor.methods
  resetCard: (id) ->
    console.log('resetCard')
    Elements.remove
      parentId: id
      headerElement: { $exists: false }
    Elements.update { parentId: id, type: 'title' },
      $set:
        body: defaults.card.title
        editable: true
    Elements.update { parentId: id, type: 'description' },
      $set:
        body: defaults.element.description
        editable: true

  deleteCard: (id, siblingElementId) ->
    Elements.remove(siblingElementId)
    Elements.remove(parentId: id)
    Cards.remove(id)
