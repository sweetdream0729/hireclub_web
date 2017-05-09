$(document).ready ->
  skillSearch = (query, syncResults, asyncResults) ->
    $.get '/skills.json', { query: query }, ((data) ->
      asyncResults data
      return
    ), 'json'
    return

  $('input#user_skill_skill').typeahead {
    minLength: 0
    hint: false
    highlight: true
  },
    name: 'skill-search-results'
    source: skillSearch
    display: (skill) ->
      skill.name

  window.initilize_typehead =  () ->
    $('.autocomplete_skill').typeahead {
      minLength: 0
      hint: false
      highlight: true
    },
      name: 'skill-search-results'
      source: skillSearch
      display: (skill) ->
        skill.name
    # skill selected, let's set hidden skill_id field
    $('input#user_skill_skill').bind 'typeahead:select', (ev, skill) ->
      # Set hidden form field of skill_id
      $('input#user_skill_skill_id').val skill.id
      return
    $('.autocomplete_skill').bind 'typeahead:select', (ev, skill) ->
  # Set hidden form field of skill_id
      skill_id = $(this).parent().parent().find('.autocomplete_skill_id')[0];
      console.log(skill_id);
      $(skill_id).val(skill.id);
      return
    return
  window.initilize_typehead();
# ---
# generated by js2coffee 2.2.0