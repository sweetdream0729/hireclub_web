$(document).ready ->
  # pre-connection
  setupProviderCreate()

setupProviderCreate = ->
  providerForm = $('#provider_new')
  tosElement = $('.tos').find('input')
  selectedCountry = $('#provider_country')
  createButton = $('#create_provider_btn')
  createButton.attr("disabled", true)
  tosElement.change -> 
    if tosElement.is(':checked')
      createButton.removeAttr "disabled"
    else 
      createButton.attr("disabled", true)
  providerForm.submit ( e ) ->
    # prevent creation unless ToS is checked
    if !tosElement.is(':checked')
      e.preventDefault()
      return false
    createButton.attr("disabled", true)

  # populate appropriate ToS link depending on dropdown
  selectedCountry.change ->
    termsUrl = "https://stripe.com/#{countrySelect.val().toLowerCase()}/terms"
    tosElement.siblings('a').attr( href: termsUrl )
