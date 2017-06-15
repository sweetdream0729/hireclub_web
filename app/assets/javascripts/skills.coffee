$(document).ready ->
  $('#new_skill').formValidation(
    framework: 'bootstrap4'
    icon:
      valid: 'fa fa-check'
      invalid: 'fa fa-times'
      validating: 'fa fa-refresh'
    fields:
      'skill[name]': validators:
        remote:
          message: ' ',
          url: '/skills/available.json',
          delay: 300,
          name: 'q',
          validKey: 'available'

  ).on('success.validator.fv', (e, data) ->
    
    if data.field == "skill[name]" && data.validator == "remote"
      hint = $('#existing_skill')
      hint.text("")
    return
  ).on('err.validator.fv', (e, data) ->
    console.log(data)
    if data.field == "skill[name]" && data.validator == "remote"
      hint = $('#existing_skill')
      hint.text("A similar skill " + data.result.skill + " already exists.")
    return
  )

  return

# ---
# generated by js2coffee 2.2.0
