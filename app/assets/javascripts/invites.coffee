$(document).ready ->
  $('#new_invite').formValidation(
    framework: 'bootstrap4'
    icon:
      valid: 'fa fa-check'
      invalid: 'fa fa-times'
      validating: 'fa fa-refresh'
    fields:
      'invite[email]':
        trigger: 'blur'
        validators:
          notEmpty: 
            message: 'Email is required'
          regexp: 
            regexp: '^[^@\\s]+@([^@\\s]+\\.)+[^@\\s]+$',
            message: 'Not a valid email address'
  )

  return

# ---
# generated by js2coffee 2.2.0
