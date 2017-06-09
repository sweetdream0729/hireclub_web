$(document).ready ->
  selectizeCallback = null

  # reset company create form when modal closes
  $('.company-modal').on 'hide.bs.modal', (e) ->
    if selectizeCallback != null
      selectizeCallback()
      selecitzeCallback = null
    $('#new_company').trigger 'reset'
    $.rails.enableFormElements $('#new_company')
    return

  #submitting form data via ajax
  $('#new_company').on 'submit', (e) ->
    e.preventDefault()
    $.ajax
      method: 'POST'
      url: $(this).attr('action')
      data: $(this).serialize()
      success: (response) ->
        selectizeCallback
          id: response.id
          name: response.name
          avatar_url: response.avatar_url
        selectizeCallback = null
        $('.company-modal').modal 'toggle'
        return
    return

  $('.autocomplete_company').selectize
    plugins: ['restore_on_backspace']
    valueField: 'id'
    labelField: 'name'
    searchField: 'name'
    maxItems: 1
    maxOptions: 8
    persist: false
    placeholder: 'hireclub'
    render: option: (item, escape) ->
      (if item.avatar_url then ('<div>' + '<img class="mr-2 rounded" width="50" src="' +  escape(item.avatar_url) + '"/>' + '<strong>' + item.name + '</strong> ' + '</div>') else '<span></span>')

    load: (query, callback) ->
      if !query.length
        return callback()
      $.ajax
        url: '/companies'
        type: 'GET'
        dataType: 'json'
        data:
          query: query
          sort_by: "popular"
        error: ->
          callback()
          return
        success: (res) ->
          callback res
          return
      return
    onItemAdd: (value, item) ->
      $('.autocomplete_company_id').val value
      return
    create: (input, callback) ->
      selectizeCallback = callback
      $('.company-modal').modal()
      $('#company_name').val input
      return
