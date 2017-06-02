class ApplicationMailer < ActionMailer::Base
  add_template_helper(ApplicationHelper)
  default from: "HireClub <no-reply@#{Rails.application.secrets.domain_name}>"
  layout 'mailer'
end
