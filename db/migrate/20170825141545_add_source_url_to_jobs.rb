class AddSourceUrlToJobs < ActiveRecord::Migration[5.0]
  def change
    add_column :jobs, :source_url, :string
  end
end
