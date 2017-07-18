$(document).ready ->
  if $('#previous_project').length > 0
    Mousetrap.bind 'left', ->
      document.getElementById("previous_project").click()
      return
  if $('#next_project').length > 0
    Mousetrap.bind 'right', ->
      document.getElementById("next_project").click()
      return

  $('.project_form').formValidation(
    framework: 'bootstrap4'
    icon:
      valid: 'fa fa-check'
      invalid: 'fa fa-times'
      validating: 'fa fa-refresh'
    fields:
      'project[name]':
        validators:
          notEmpty: 
            message: 'Name is required.'
          stringLength:
            max: 64
            message: 'Name must be less than 64 characters.'
                
    )

  $('#project_skills_list').selectize
    plugins: ['remove_button']
    delimiter: ','
    searchField: 'name'
    valueField: 'name'
    labelField: 'name'
    selectOnTab: true
    closeAfterSelect: true

    #show create new skill only if there is no matching skills in dropdown
    render: option_create: (data, escape) ->
      if this.$dropdown_content.find('.option').length > 0
        return ''
      else
        return '<div class="create">Add <strong>' + escape(data.input) + '</strong>&hellip;</div>'

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
    create: (input, callback) ->
      window.selectizeCallback = callback
      $('#createSkillModal').modal()
      $('#skill_name').val input
      return

  # Configure infinite scroll
  $('.infinite-projects').infinitePages
    loading: ->
      $(this).text('Loading...')
    error: ->
      $(this).button('There was an error, please try again')