$(document).ready ->
  selectizeCallback = null

  # reset company create form when modal closes
  $('#createCompanyModal').on 'hide.bs.modal', (e) ->
    if selectizeCallback != null
      selectizeCallback()
      selectizeCallback = null
    $('.company_new').trigger 'reset'
    $.rails.enableFormElements $('.company_new')
    return

  #handles response when company creation is successful
  $(".company_new").on("ajax:success", (e, response) ->
    selectizeCallback
      id: response.id
      name: response.name
      avatar_url: response.avatar_url
    selectizeCallback = null
    $('#createCompanyModal').modal 'toggle'
    return
  ).on "ajax:error", (e, response) ->


  $('.autocomplete_company').selectize
    plugins: ['restore_on_backspace']
    valueField: 'id'
    labelField: 'name'
    searchField: 'name'
    maxItems: 1
    maxOptions: 8
    placeholder: 'Acme Inc'
    preload: 'focus'
    render: option: (item, escape) ->
      (if item.avatar_url then ('<div>' + '<img class="mr-2 rounded" width="50" src="' +  escape(item.avatar_url) + '"/>' + '<strong>' + item.name + '</strong> ' + '</div>') else '<span></span>')

    load: (query, callback) ->
      if !query.length
        data =
          sort_by: "popular"
      else
        data =
          query: query
          sort_by: "popular"
      $.ajax
        url: '/companies'
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
      $('.autocomplete_company_id').val value
      return
    onItemRemove: (value) ->
      $('.autocomplete_company_id').val null
      return
    create: (input, callback) ->
      selectizeCallback = callback
      $('#createCompanyModal').modal()
      #$('#company_name').val input
      return
