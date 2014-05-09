@defaults =
  dateformats:
    datetime: 'dddd Do MMMM - h:mm a'
    date: 'dddd Do MMMM'
    time: 'h:mm a'
  itinerary:
    valid_insert_attributes: ['_id', 'user_id', 'document_type', 'created_on']
    document_type: 'itinerary'
    title: 'Itinerary title'
  card:
    valid_insert_attributes: ['_id', 'user_id', 'document_type', 'parent_id', 'type']
    document_type: 'card'
    title: 'Card title'
    types: ['accommodation', 'travel', 'event']
  element:
    valid_insert_attributes: ['_id', 'user_id', 'type', 'parent_id',
                              'belongs_to', 'body', 'editable', 'position',
                              'initalElement', 'finalElement']
    valid_editable_attributes: ['body', 'second_body', 'original_body', 'position', 'editable',
                                'card_type', 'card_title', 'card_description']
    types: ['datetime-local', 'description', 'divider', 'title',
            'photo', 'text', 'link', 'date', 'time', 'card', 'map']
    'datetime-local':
      body: 'Specify a date and time'
      prototype: DateTimeElement.prototype
    description:
      body: 'A short description'
      prototype: DescriptionElement.prototype
    divider:
      prototype: DividerElement.prototype
    title:
      body: 'A title'
      prototype: TitleElement.prototype
    photo:
      body: 'Link a photo'
      prototype: PhotoElement.prototype
    text:
      body: 'Add some text'
      prototype: TextElement.prototype
    link:
      body: 'Link the interwebs'
      prototype: LinkElement.prototype
    date:
      body: 'Specify a date'
      prototype: DateTimeElement.prototype
    time:
      body: 'Specify a time'
      prototype: DateTimeElement.prototype
    card:
      prototype: CardElement.prototype
    map:
      body: 'Enter an address'
      prototype: MapElement.prototype
