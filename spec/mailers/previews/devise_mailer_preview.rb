# mailer/previews/devise_mailer_preview.rb
class Devise::MailerPreview < ActionMailer::Preview

  def confirmation_instructions
    CustomDeviseMailer.confirmation_instructions(User.first, "faketoken")
  end

  def reset_password_instructions
    CustomDeviseMailer.reset_password_instructions(User.first, "faketoken")
  end

end