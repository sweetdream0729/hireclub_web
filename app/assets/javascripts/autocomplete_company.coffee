$(document).ready ->
  $('.autocomplete_company').selectize
    plugins: ['restore_on_backspace'],
    valueField: 'id'
    labelField: 'name'
    searchField: 'name'
    create: false
    maxItems: 1
    maxOptions: 8
    render: option: (item, escape) ->
      (if item.avatar_url then ('<div>' + '<img class="mr-2 rounded" width="50" src="' +  escape(item.avatar_url) + 'alt="" />' + '<strong>' + item.name + '</strong> ' + '</div>') else '<span></span>')

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
