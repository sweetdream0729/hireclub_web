$(document).ready ->
  messages = $('#messages')

  if $('#messages').length > 0
    messages_to_bottom = -> messages.scrollTop(messages.prop("scrollHeight"))

    messages_to_bottom()

    App.global_chat = App.cable.subscriptions.create {
        channel: "ConversationsChannel"
        conversation_id: messages.data('conversation-id')
      },
      connected: ->
        # Called when the subscription is ready for use on the server

      disconnected: ->
        # Called when the subscription has been terminated by the server

      received: (data) ->
        messages.append data['message']
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