@showOpeners = ->
  $('#openElementButtonContainer').show()
  $('#openCardsContainer').show()
  hideContainers()
@hideContainers = ->
  $('#dateTimeElementsContainer').hide()
  $('#elementButtonContainer').hide()
  $('#cardsContainer').hide()
@openCardsContainer = ->
  $('#openElementButtonContainer').hide()
  $('#openCardsContainer').hide()
  $('#cardsContainer').show()
@openElementsContainer = ->
  $('#openElementButtonContainer').hide()
  $('#openCardsContainer').hide()
  $('#elementButtonContainer').show()
@openDateTimeElementsContainer = ->
  $('#elementButtonContainer').hide()
  $('#dateTimeElementsContainer').show()

@hideLoginRegistrationOpeners = ->
  $('#showLoginForm').hide()
  $('#showRegistrationForm').hide()
@showLoginRegistrationOpeners = ->
  $('#showLoginForm').show()
  $('#showRegistrationForm').show()
  $('#loginForm').hide()
  $('#registrationForm').hide()
