module ApplicationCable
  class Connection < ActionCable::Connection::Base
  	identified_by :current_user

  	def connect
      self.current_user = find_authenticated_user
      logger.add_tags 'ActionCable', current_user.email
    end

    protected

    def find_authenticated_user # this checks whether a user is authenticated with devise
      if authenticated_user = env['warden'].user
        authenticated_user
      else
        reject_unauthorized_connection
      end
    end

  end
end
