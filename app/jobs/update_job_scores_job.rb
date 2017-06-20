class UpdateJobScoresJob < ApplicationJob
  queue_as :default

  def perform(job)
    job.update_suggested_users
  end
end
