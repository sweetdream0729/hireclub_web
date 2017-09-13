class NewsletterMailer < ApplicationMailer

  def newsletter(newsletter, user)
    @newsletter = newsletter
    @user = user

    set_campaign(@newsletter.campaign_id) if @newsletter.campaign_id.present?
    add_metadata(:user_id, @user.id)
    add_metadata(:newsletter_id, @newsletter.id)

    mail(to: @user.email, subject: @newsletter.subject)
  end
end
