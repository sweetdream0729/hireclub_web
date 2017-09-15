class NewsletterMailer < ApplicationMailer

  def newsletter(newsletter, user)
    @newsletter = newsletter
    @user = user
    @unsubscribe_url = get_utm_url unsubscribe_url(@user.preference_access_token("email_newsletter"))

    set_campaign(@newsletter.campaign_id) if @newsletter.campaign_id.present?
    add_metadata(:user_id, @user.id)
    add_metadata(:newsletter_id, @newsletter.id)


    mail(to: @user.email, subject: @newsletter.subject)
  end
end
