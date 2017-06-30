class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token
  
  def sparkpost
    Rails.logger.info params.inspect
  end
end