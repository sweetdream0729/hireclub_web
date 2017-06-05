class AddSuggestedSkillsToJob < ActiveRecord::Migration[5.0]
  def change
    add_column :jobs, :suggested_skills, :string, array: true, default: []
    add_index  :jobs, :suggested_skills, using: 'gin'
  end
end
