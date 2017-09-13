class AddEmailOnJobPostToPreference < ActiveRecord::Migration[5.0]
  def change
    add_column :preferences, :email_on_job_post, :boolean, null: false, default: true
    add_index :preferences, :email_on_job_post
  end
end
