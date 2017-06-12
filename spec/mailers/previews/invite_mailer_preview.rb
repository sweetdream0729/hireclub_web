# Preview all emails at http://localhost:3000/rails/mailers/invite
class InviteMailerPreview < ActionMailer::Preview
  def invite_created
    invite = Invite.last
    InviteMailer.invite_created(invite)
  end
end
