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

# $(document).ready ->
#   messages = $('#messages')

#   if $('#messages').length > 0
#     messages_to_bottom = ->
#       chat = $('.chat_area')
#       chat.scrollTop(chat.prop("scrollHeight"))

#     messages_to_bottom()

#     App.global_chat = App.cable.subscriptions.create {
#         channel: "ConversationsChannel"
#         conversation_id: messages.data('conversation-id')
#       },
#       connected: ->
#         # Called when the subscription is ready for use on the server

#       disconnected: ->
#         # Called when the subscription has been terminated by the server

#       current_user_id: ->
#         # Passed the current logged in userid

#       received: (data) ->
#         current_user_id = App.global_chat.current_user_id
#         message_user_id = data.user_id
#         div_id = '#conversation_'+ data.conversation_id
#         text   = data.text
#         time   = data.created_at
#         unread_message_count = if data.unread_count == 0 then 1 else data.unread_count
#         if current_user_id == data.user_id
#           messages.append data['curret_user_message']
#           $(div_id).find('p.mb-0').text 'You: ' + text + ''
#           #$(div_id).find('.notification-alert').html ''
#         else
#           messages.append data['message']
#           $(div_id).find('p.mb-0').text '' + text + ''
#           #$(div_id).find('.notification-alert').html '<div class="notification-icon"><span class="glyphicon glyphicon-envelope"></span><span class="badge">' + unread_message_count + '</span></div>'
#         $(div_id).find('small').text '' + time + ''
#         messages_to_bottom()

#       send_message: (text, conversation_id) ->
#         @perform 'send_message', text: text, conversation_id: conversation_id


#     $('#new_message').submit (e) ->
#       $this = $(this)
#       input = $this.find('#message_text')
#       if $.trim(input.val()).length > 0
#         App.global_chat.send_message input.val(), messages.data('conversation-id')
#         input.val('')
#       e.preventDefault()
#       return false