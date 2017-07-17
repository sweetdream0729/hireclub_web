class App.Search
  constructor: ($nav_search_form, $nav_search_input) ->
    
    # don't submit form in nil query
    $nav_search_form.on 'submit', (event) ->
      query = $nav_search_input.val().trim()
      if query == ''
        return false
      return
    return


$(document).ready ->
  search = new App.Search $("#nav_search_form"), $("#nav_search_input")