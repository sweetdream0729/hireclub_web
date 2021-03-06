$(document).ready ->
  userSearch = (query, syncResults, asyncResults) ->
    $.get '/members.json', { query: query, sort_by: "popular" }, ((data) ->
      asyncResults data
      return
    ), 'json'
    return

  $('.autocomplete_user').typeahead {
    minLength: 0
    hint: false
    highlight: true
  },
    name: 'autocomplete_user'
    source: userSearch
    limit: 8
    display: (user) ->
      user.name
    templates:
      empty: 'not found'
      suggestion: (el) ->
        '<div>' + '<img class="mr-2 rounded-circle" width="52" src="' + el.avatar_url + '" />' + '<strong>' + el.name + '</strong></div>'

  # user selected, let's set hidden user_id field
  $('.autocomplete_user').bind 'typeahead:select', (ev, user) ->
    # Set hidden form field of user_id
    $('.autocomplete_user_id').val user.id
    return
  return

# ---
# generated by js2coffee 2.2.0