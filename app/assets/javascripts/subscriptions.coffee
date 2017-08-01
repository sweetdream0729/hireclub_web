$(document).ready ->
  subscriptionForm = document.getElementById('new_subscription')

  #handle stripe card details
  if subscriptionForm 
    public_key = document.querySelector('meta[name=\'stripe-public-key\']').content
    stripe = Stripe(public_key)
    elements = stripe.elements()

    #set style and mount
    style = base:
      fontSize: '16px',
      lineHeight: '24px'
    card = elements.create('card', style: style)
    card.mount '#card-element'

    #check for errors
    card.addEventListener 'change', (event) ->
      displayError = document.getElementById('card-errors')
      if event.error
        displayError.textContent = event.error.message
        document.getElementById('subscribe_btn').setAttribute("disabled", "disabled");
      else
        displayError.textContent = ''
        document.getElementById('subscribe_btn').removeAttribute("disabled");

      return

  if subscriptionForm
    subscriptionForm.addEventListener 'submit', (event) ->
  	  #check if card is present
  	  document.getElementById('subscribe_btn').setAttribute("disabled", "disabled");
	    event.preventDefault()
	    stripe.createToken(card).then (result) ->
	      if result.error
	        # show error
	        errorElement = document.getElementById('card-errors')
	        errorElement.textContent = result.error.message
	        document.getElementById('subscribe_btn').disable = false;
	      else
	        # add stripeToken to form and submit
	        stripeTokenHandler result.token, subscriptionForm
	      return
      return

  stripeTokenHandler = (token, form) ->
    hiddenInput = document.createElement('input')
    hiddenInput.setAttribute 'type', 'hidden'
    hiddenInput.setAttribute 'name', 'stripeToken'
    hiddenInput.setAttribute 'value', token.id
    form.appendChild hiddenInput

    form.submit()
    return
