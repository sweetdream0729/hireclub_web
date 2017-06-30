class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def sparkpost
    Rails.logger.info params.inspect

    params[:_json].each do |item|
      Rails.logger.info item.inspect      
    end
  end
end