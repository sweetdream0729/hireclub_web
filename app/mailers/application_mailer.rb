class ApplicationMailer < ActionMailer::Base
  include Trackable

  add_template_helper(ApplicationHelper)
  default from: "HireClub <no-reply@#{Rails.application.secrets.domain_name}>"
  layout 'mailer'
  after_action :set_sparkpost_header

end
