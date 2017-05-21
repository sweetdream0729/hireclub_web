App.typing = App.cable.subscriptions.create "TypingChannel",
  connected: ->
    # Called when the subscription is ready for use on the server
    return

  disconnected: ->
    # Called when the subscription has been terminated by the server
    return

  received: (data) ->
    console.log(data)
    active_conversation = $("[data-behavior='messages'][data-conversation-id='#{data.conversation_id}']")
    console.log("currentUser: " + App.currentUser)
    is_current_user = data.user_id.toString() == App.currentUser.toString()
    console.log("is_current_user: " + is_current_user)
    # if we are viewing this conversation id
    if active_conversation.length > 0 && !is_current_user
      App.typing.showTypingIndicator(data.is_typing)
    return

  is_typing: (conversation_id, is_typing) ->
    console.log(conversation_id, is_typing)
    @perform "is_typing", {conversation_id: conversation_id, is_typing: is_typing}
    return


  showTypingIndicator: (show) ->
    console.log("showTypingIndicator " +show)
    el = $("#typing_indicator")
    if show
      $("#messages").append(el)
      el.show()
    else
      el.hide()
    App.conversations.scrollToBottom()
    return

$(document).ready ->  
  # Scroll to bottom when starting conversation
  App.typing.showTypingIndicator(false)

  $("#message_text").idle
    onIdle: ->
      console.log("idle")

      conversation_id = $("#message_conversation_id").val()
      App.typing.is_typing(conversation_id, false)
      return

    onActive: ->
      console.log("active")
      App.presence.setCurrentUserActive()

      conversation_id = $("#message_conversation_id").val()
      App.typing.is_typing(conversation_id, true)
      return
    idle: 3000
    events: "keydown"
