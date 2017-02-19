class FacebookService

  def self.get_client
    @user ||= User.find_by(username: Rails.application.secrets.facebook_import_username || 'kidbombay')
    @graph ||=  Koala::Facebook::API.new(@user.get_fb_token)
  end

  def self.search_pages(query)
    self.get_client.search(query, {type: "page", fields: "id,name,picture,link",limit: 5})
  end

  
end