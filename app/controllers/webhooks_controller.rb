class WebhooksController < ApplicationController

  def sparkpost
    Rails.logger.info params.inspect
  end
end