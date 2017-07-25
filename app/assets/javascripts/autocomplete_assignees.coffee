$(document).ready ->

  $('.autocomplete_assignee').selectize
    valueField: 'id'
    labelField: 'name'
    searchField: 'name'
    maxItems: null
    maxOptions: 8
    placeholder: 'Add assignee'
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
    