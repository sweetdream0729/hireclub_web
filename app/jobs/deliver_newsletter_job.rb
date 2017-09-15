class DeliverNewsletterJob < ApplicationJob
  queue_as :urgent

  def perform(newsletter)
    newsletter.deliver!
  end
end
