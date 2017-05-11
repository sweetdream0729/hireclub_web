$(document).ready ->
  messages = $('#messages')
  conversation_list = $('#conversations');

  if $('#messages').length > 0
    messages_to_bottom = ->
      chat = $('.chat_area')
      chat.scrollTop(chat.prop("scrollHeight"))

    messages_to_bottom()

    App.global_chat = App.cable.subscriptions.create {
        channel: "ConversationsChannel"
        conversation_id: messages.data('conversation-id')
      },
      connected: ->
        # Called when the subscription is ready for use on the server

      disconnected: ->
        # Called when the subscription has been terminated by the server

      current_user_id: ->
        # Passed the current logged in userid

      received: (data) ->
        current_user_id = App.global_chat.current_user_id
        message_user_id = data.user_id
        if current_user_id == data.user_id
          messages.append data['curret_user_message']
        else
          messages.append data['message']
        #conversation_list.html data['conversation_list']
        messages_to_bottom()

      send_message: (text, conversation_id) ->
        @perform 'send_message', text: text, conversation_id: conversation_id


    $('#new_message').submit (e) ->
      $this = $(this)
      input = $this.find('#message_text')
      if $.trim(input.val()).length > 0
        App.global_chat.send_message input.val(), messages.data('conversation-id')
        input.val('')
      e.preventDefault()
      return false