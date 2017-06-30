class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def sparkpost
    #Rails.logger.info params.inspect

    params[:_json].each do |item|
      if item["msys"] && item["msys"]["message_event"]
        Rails.logger.info item.inspect 
      end
    end
  end
end