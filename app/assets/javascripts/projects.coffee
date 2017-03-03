$(document).ready ->
  Mousetrap.bind 'left', ->
    document.getElementById("previous_project").click()
    return
  Mousetrap.bind 'right', ->
    document.getElementById("next_project").click()
    return

