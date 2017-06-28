module Admin::ConversationUserAdmin
  extend ActiveSupport::Concern

  included do
    rails_admin do
      
      list do
        scopes [nil, :unread, :unread_notified]
      end
    end
  end
end