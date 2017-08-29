$(document).ready ->

  payeeSelect = $('.autocomplete_payee').selectize
    valueField: 'id'
    labelField: 'name'
    searchField: 'name'
    maxItems: 1
    maxOptions: 8
    placeholder: 'Add Payee'
    preload: 'focus'
    closeAfterSelect: true
    render: option: (item, escape) ->
      (if item.avatar_url then ('<div>' + '<img class="mr-2 rounded" width="50" src="' +  escape(item.avatar_url) + '"/>' + '<strong>' + item.name + '</strong> ' + '</div>') else '<span></span>')

    load: (query, callback) ->
      if !query.length
        data =
          sort_by: "alphabetical"
      else
        data =
          query: query
          sort_by: "alphabetical"
      $.ajax
        url: '/members'
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