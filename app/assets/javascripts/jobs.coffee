//= require jquery.are-you-sure

$(document).ready ->
  $('select').on 'change', (e) ->
    value = @value
    if value == 'annually'
      $('.suffix_annually').removeClass("d-none")
    else
      $('.suffix_annually').addClass("d-none")
    
    
    console.log(value)
    return

  $('.job_form').formValidation(
    framework: 'bootstrap4'
    icon:
      valid: 'fa fa-check'
      invalid: 'fa fa-times'
      validating: 'fa fa-refresh'
    fields:
      'job[name]':
        validators:
          notEmpty: 
            message: 'Title is required.'
    )

  $('#job_skills_list').selectize
    plugins: ['remove_button']
    delimiter: ','
    searchField: 'name'
    valueField: 'name'
    labelField: 'name'
    selectOnTab: true
    create: false
    load: (query, callback) ->
      if !query.length
        return callback()
      $.ajax
        url: '/skills.json'
        type: 'GET'
        data:
          query: encodeURIComponent(query)
        error: ->
          callback()
          return
        success: (response) ->
          callback response
          return
      return

  $('form.job_form').areYouSure
    'message': 'Are you sure? You will lose any changes.'
