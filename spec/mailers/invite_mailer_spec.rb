require "rails_helper"

RSpec.describe InviteMailer, type: :mailer do
  let(:invite) { FactoryGirl.create(:invite) }
 
  describe "invite_created" do
    let(:mail) do 
      InviteMailer.invite_created(invite)
    end

    it 'renders the email' do
      expect(mail.subject).to eq("#{invite.user.display_name} invited you to HireClub")
      expect(mail.to).to eq([invite.input])
    end
  end
end
