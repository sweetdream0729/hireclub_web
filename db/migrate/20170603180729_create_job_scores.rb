class CreateJobScores < ActiveRecord::Migration[5.0]
  def change
    create_table :job_scores do |t|
      t.references :user, foreign_key: true, null: false
      t.references :job, foreign_key: true, null: false
      t.integer :score, null: false, default: 0

      t.timestamps
    end

    add_index :job_scores, [:user_id, :job_id], unique: true
  end
end
