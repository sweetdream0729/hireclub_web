$(document).ready ->
  $('#milestone_skills_list').selectize
    plugins: ['remove_button']
    delimiter: ','
    searchField: 'name'
    valueField: 'name'
    labelField: 'name'
    selectOnTab: true
    create: false
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

  options =
    format: 'mm/dd/yyyy'
    endDate: new Date()

  $('.datepicker').datepicker options
    

  #for milestones fields which are added dynamically via cocoon
  $('#milestones').on 'cocoon:after-insert', (e, element_added)->
    element_added.find('.datepicker').datepicker options
