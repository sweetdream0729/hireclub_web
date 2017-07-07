class ImportFacebookHistoryJob < ApplicationJob
  queue_as :urgent

  def perform(user, omniauth)
    education = omniauth["extra"]["raw_info"]["education"]
    user.import_education_from_facebook(education) if education.present?
    
    work = omniauth["extra"]["raw_info"]["work"]
    user.import_work_from_facebook(work) if work.present?

    location = omniauth["extra"]["raw_info"]["location"]

    Location.import_facebook_id(location["id"]) if location.present?
  end
end
