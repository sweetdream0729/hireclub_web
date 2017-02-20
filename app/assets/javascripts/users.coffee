$(document).ready ->
  $('[data-toggle="tooltip"]').tooltip()
  el = document.getElementById('sortable_user_skills')
  sortable = Sortable.create(el, {
    onEnd: (event) ->
      user_skill_id = $(event.item).attr("data-id");
      $.ajax
        type: 'PUT'
        url: '/user_skills/' + user_skill_id
        data: user_skill: position: event.newIndex
      return


  })
