$(document).ready ->
  $('.at_who_mentions').atwho
    at: '@'
    callbacks: remoteFilter: (query, callback) ->
      $.get '/members', { query: query }, ((data) ->
        callback data
        return
      ), 'json'
      return
