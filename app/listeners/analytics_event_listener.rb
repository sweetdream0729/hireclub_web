class AnalyticsEventListener
  def create_analytics_event(analytics_event)
    process_email_bounce(analytics_event)
  end

  def process_email_bounce(analytics_event)
    if analytics_event.key == EmailBounceActivity::KEY || analytics_event.key == EmailBounceActivity::REJECTION_KEY

      data = analytics_event.data

      campaign_id = data["campaign_id"]
      rcpt_meta = data["rcpt_meta"]
      
      if data.present? && rcpt_meta.present? && campaign_id == InviteCreateActivity::KEY 
        invite = Invite.where(id: rcpt_meta["invite_id"].to_i).first
        if invite.present?
          invite.mark_bounced!
        end
      end
    end
  end
end