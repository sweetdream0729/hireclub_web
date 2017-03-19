$(document).ready ->
  Mousetrap.bind 'left', ->
    document.getElementById("previous_project").click()
    return
  Mousetrap.bind 'right', ->
    document.getElementById("next_project").click()
    return
  $('#project_skills_list').selectize
	  delimiter: ','
	  persist: false
	  create: (input) ->
	    {
	      value: input
	      text: input
	    }

