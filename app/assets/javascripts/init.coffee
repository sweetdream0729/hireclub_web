window.App ||= {}

App.init = ->
  $('[data-toggle="tooltip"]').tooltip()

$(document).ready ->
  App.init()