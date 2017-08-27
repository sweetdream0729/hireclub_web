window.App ||= {}

App.init = ->
  $('[data-toggle="tooltip"]').tooltip()
  App.currentUser = $("meta[name=currentUser]").attr("content")
  if App.currentUser
    OneSignal.push(["sendTags", {user_id: App.currentUser}]);

  Cookies.set('browser.timezone', jstz.determine().name(), { expires: 30 });

$(document).ready ->
  App.init()
