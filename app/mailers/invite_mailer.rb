class InviteMailer < ApplicationMailer

  def invite_created(invite)
    set_invite(invite)
    @subject = "#{@user.display_name} invited you to HireClub"
    if invite.recipient.present?
      @subject = "#{@user.display_name} sent you their HireClub Profile"
    end

    @invite_url = get_utm_url url_for(@invite)

    mail(to: @invite.input, subject: @subject, reply_to: @invite.user.email)
  end

  def set_invite(invite)
    @invite = Invite.find(invite.id)
    @user = @invite.user

    if @invite.present?
      set_campaign(InviteCreateActivity::KEY)
      add_metadata(:invite_id, @invite.id)
      add_metadata(:user_id, @user.try(:id))
      add_metadata(:activity_id, @invite.try(:activity).try(:id))
    end
  end
end
