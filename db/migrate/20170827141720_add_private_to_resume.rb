class AddPrivateToResume < ActiveRecord::Migration[5.0]
  def change
    add_column :resumes, :private, :boolean, null: false, default: false
    add_index :resumes, :private
  end
end
