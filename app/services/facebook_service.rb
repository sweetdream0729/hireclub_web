class FacebookService

  def self.get_client
    @user ||= User.find_by(username: Rails.application.secrets.facebook_import_username || 'kidbombay')
    @graph ||=  Koala::Facebook::API.new(@user.get_fb_token)
  end

  
end