require 'rails_helper'

RSpec.describe AnalyticsEventListener, :type => :model do
  
  describe "invite bounce" do
    let(:invite) { FactoryGirl.create(:invite) }

    it "should listen for bounces" do
      expect(invite).to be_persisted
      user = invite.user

      key = EmailBounceActivity::KEY
      json = '{ "type": "bounce", "tdate": "2017-06-29T13:11:58.000Z", "reason": "550-5.1.1 The email account that you tried to reach does not exist. Please try\r\n550-5.1.1 double-checking the recipients email address for typos or\r\n550-5.1.1 unnecessary spaces. Learn more at\r\n550 5.1.1 https://support.google.com/mail/?p=NoSuch... - gsmtp", "ip_pool": "shared", "rcpt_to": "nobody@kidbombay.com", "subject": "Ketan Anjaria invited you to HireClub", "event_id": "12571926265887433", "msg_from": "msprvs1=17353dDNJGUPh=bounces-160183@bounce.hireclub.co", "msg_size": "27674", "rcpt_meta": { "user_id": "' + user.id.to_s + '", "invite_id": "' + invite.id.to_s + '", "campaign_id": "invite.create" }, "rcpt_tags": [ ], "timestamp": "2017-06-29T13:11:58.000+00:00", "error_code": "550", "ip_address": "74.125.28.26", "message_id": "00009dfc545941c289b3", "queue_time": "735", "raw_reason": "550-5.1.1 The email account that you tried to reach does not exist. Please try\r\n550-5.1.1 double-checking the recipients email address for typos or\r\n550-5.1.1 unnecessary spaces. Learn more at\r\n550 5.1.1 https://support.google.com/mail/?p=NoSuchUser x187si3819157pgx.147 - gsmtp", "sending_ip": "35.161.146.30", "campaign_id": "invite.create", "customer_id": "160183", "num_retries": "0", "raw_rcpt_to": "nobody@kidbombay.com", "template_id": "smtp_12571926257063073", "bounce_class": "10", "friendly_from": "no-reply@hireclub.co", "transactional": "1", "routing_domain": "google.com", "transmission_id": "12571926257063073", "template_version": "0" }'
      data = JSON.parse(json)
      analytics_event = FactoryGirl.create(:analytics_event, key: key, data: data, user: user)

      expect(analytics_event).to be_persisted

      activity = Activity.where(key: InviteBounceActivity::KEY).last
      expect(activity).to be_present
      expect(activity.trackable).to eq invite
      expect(activity.owner).to eq invite.user
      expect(activity.published).to be true
      expect(activity.private).to be true
    end
  end
end