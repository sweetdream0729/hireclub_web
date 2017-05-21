App.conversations = App.cable.subscriptions.create "ConversationsChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # console.log(data)
    
    text = data.message.text
    active_conversation = $("[data-behavior='messages'][data-conversation-id='#{data.conversation_id}']")
    # if we are viewing this conversation id
    if active_conversation.length > 0  
      partial = data.message_partial
      
      # If the message is coming current user append my_message class
      if data.user_id.toString() == App.currentUser.toString()
        partial = data.message_partial.replace("<div class='message'>", "<div class='message my_message'>");
        text = "You: " + text

      # Insert the message
      active_conversation.append(partial)
      App.conversations.scrollToBottom()

    conversation_list_item = $("#conversation_#{data.conversation_id}")
    if conversation_list_item.length > 0
        preview = conversation_list_item.find(".conversation_preview")
        preview.text(text)

    

  send_message: (conversation_id, text) ->
    # Calls ConversationsChannel.send_messsage
    @perform "send_message", {conversation_id: conversation_id, text: text}

  scrollToBottom: ->
    chat = $('#messages')
    scrollHeight = chat.prop("scrollHeight")
    chat.scrollTop(scrollHeight)


$(document).ready ->  
  # Scroll to bottom when starting conversation
  App.conversations.scrollToBottom()
  
  # submit message on enter
  $("#new_message").on "keypress", (e) ->
    if e && e.keyCode == 13
      e.preventDefault()
      $(this).submit()

  # Use Channel to send message
  $("#new_message").on "submit", (e) ->
    e.preventDefault()

    conversation_id = $("#message_conversation_id").val()
    text_field = $("#message_text")

    App.conversations.send_message(conversation_id, text_field.val())

    text_field.val("")

  return
