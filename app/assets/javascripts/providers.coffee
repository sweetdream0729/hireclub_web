$(document).ready ->
  # pre-connection
  setupProviderCreate()
  $('#new_provider').formValidation(
    framework: 'bootstrap4'
    fields:
      'provider[first_name]':
        validators:
          notEmpty: 
            message: 'Your first name is required.'
      'provider[last_name]':
        validators:
          notEmpty: 
            message: 'Your last name is required.'
      'provider[date_of_birth]':
        validators:
          notEmpty: 
            message: 'Date of birth is required.'
      'provider[ssn]':
        validators: 
          regexp:
              regexp: /^(?!219099999|078051120)(?!666|000|9\d{2})\d{3}(?!00)\d{2}(?!0{4})\d{4}$/
              message: 'Invalid SSN. It should be 9 digits with no dashes.'
          notEmpty: 
            message: 'Your SSN is required.'
      'provider[phone]':
        validators:
            phone:
                country: 'US'
          notEmpty: 
            message: 'Your phone is required.'
      'provider[address_line_1]':
        validators:
          notEmpty: 
            message: 'Address line 1 is required.'
      'provider[city]':
        validators:
          notEmpty: 
            message: 'City is required.'
      'provider[state]':
        validators:
          notEmpty: 
            message: 'State is required.'
      'provider[postal_code]':
        validators:
          notEmpty: 
            message: 'Postal code is required.'
      'provider[country]':
        validators:
          notEmpty: 
            message: 'Country is required.'
      'provider[id_proof]':
        validators:
          notEmpty: 
            message: 'A valid US ID is required.'
      'tos':
        validators:
          notEmpty: 
            message: 'Required'
  ).on('success.validator.fv', (e, data) ->
    
  ).on('err.validator.fv', (e, data) ->
    
  )


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


