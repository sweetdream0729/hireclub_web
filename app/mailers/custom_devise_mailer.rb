class CustomDeviseMailer < Devise::Mailer
  include Trackable   
  helper :application # gives access to all helpers defined within `application_helper`.
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`
  default template_path: 'devise/mailer' # to make sure that your mailer uses the devise views

  after_action :set_sparkpost_header
end