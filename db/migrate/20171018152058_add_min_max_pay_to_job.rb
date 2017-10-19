class AddMinMaxPayToJob < ActiveRecord::Migration[5.0]
  def change
    add_column :jobs, :pay_type, :string, null: false, default: Job::ANNUALLY
    add_column :jobs, :min_pay, :integer, default: 0
    add_column :jobs, :max_pay, :integer
  end
end