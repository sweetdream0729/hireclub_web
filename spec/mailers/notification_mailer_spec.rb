require "rails_helper"

RSpec.describe NotificationMailer, type: :mailer do
  let(:user) { FactoryGirl.create(:user) }
 
  before do
    allow(Notification).to receive(:delay).and_return(Notification)
  end

  describe "follow_user" do
    let(:user2) { FactoryGirl.create(:user) }
    let(:mail) do 
      user2.follow(user)
      
      activity = Activity.where(key: UserFollowActivity::KEY).last
      expect(activity).to be_present

      CreateNotificationJob.perform_now(activity)

      notification = Notification.where(activity: activity).last
      expect(notification).to be_present

      NotificationMailer.user_followed(notification)
    end

    it 'renders the email' do
      expect(mail.subject).to eq("#{user2.display_name} followed you on HireClub")
      expect(mail.to).to eq([user.email])

      #puts mail.header['X-MSYS-API'].value
    end

  end
end
