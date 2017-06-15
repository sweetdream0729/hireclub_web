$(document).ready ->
  selectizeCallback = null

  # reset skill create form when modal closes
  $('#createSkillModal').on 'hide.bs.modal', (e) ->
    if selectizeCallback != null
      selectizeCallback()
      selectizeCallback = null
    $('.skill_new').trigger 'reset'
    $.rails.enableFormElements $('.skill_new')
    return

  #handles response when skill creation is successful
  $(".skill_new").on("ajax:success", (e, response) ->
    selectizeCallback
      id: response.id
      name: response.name
    selectizeCallback = null
    $('#createSkillModal').modal 'toggle'
    return
  ).on "ajax:error", (e, response) ->

  #options for initializing selectize
  options =
    plugins: ['restore_on_backspace']
    valueField: 'id'
    labelField: 'name'
    searchField: 'name'
    maxItems: 1
    maxOptions: 8
    placeholder: 'Design'
    hideSelected: true
    preload: 'focus'
    load: (query, callback) ->
      if !query.length
        data =
          sort_by: "popular"
      else
        data =
          query: query
          sort_by: "popular"
      $.ajax
        url: '/skills'
        type: 'GET'
        dataType: 'json'
        data: data
        error: ->
          callback()
          return
        success: (res) ->
          callback res
          return
      return
    onItemAdd: (value, item) ->
      item.parent().parent().next().val value
      return
    onItemRemove: (value) ->
      $(this)[0].$input.parent().find('.autocomplete_skill_id').val null
      return
    create: (input, callback) ->
      selectizeCallback = callback
      $('#createSkillModal').modal()
      #$('#skill_name').val input
      return

  #initialize all skill input field with selectize
  $('.autocomplete_skill').selectize(options)

  #for skill fields which are added dynamically via cocoon
  $('#user_skills').on 'cocoon:after-insert', (e, element_added)->
    element_added.find('.autocomplete_skill').selectize(options)
