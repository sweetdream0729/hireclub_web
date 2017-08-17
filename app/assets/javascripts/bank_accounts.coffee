$(document).ready ->
  bankAccountForm = $('#new_bank_account')
  public_key = document.querySelector('meta[name=\'stripe-public-key\']').content
  stripe = Stripe(public_key)
  submitBtn = document.getElementById('bank_account_btn')
  bankAccountForm.on 'submit', (event) ->
    event.preventDefault()
    submitBtn.setAttribute("disabled", "disabled")
    stripe.createToken('bank_account', {
      country: 'us',
      currency: 'usd',
      routing_number: $('input[name="bank_account[routing_number]"]').val(),
      account_number: $('input[name="bank_account[account_number]"]').val(),
      account_holder_name: $('input[name="bank_account[holder_name]"]').val(),
      account_holder_type: 'individual',
    }).then (result) ->
      console.log(result)
      if result.error
        error_field = $('input[name="'+ result.error.param + '"]').data('stripe')
        console.log(error_field)
        submitBtn.removeAttribute("disabled")
        alert( error_field + " " + result.error.message )
      else
        stripeBankTokenHandler result.token, bankAccountForm
      return
  return

stripeBankTokenHandler = (token, form) ->
  console.log(token)
  hiddenInput = document.createElement('input')
  hiddenInput.setAttribute 'type', 'hidden'
  hiddenInput.setAttribute 'name', 'stripeToken'
  hiddenInput.setAttribute 'value', token.id
  form.append hiddenInput

  form.unbind().submit()
  return
