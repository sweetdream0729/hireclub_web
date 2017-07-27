class AddAssigneesCountToAppointments < ActiveRecord::Migration

  def change
    add_column :appointments, :assignees_count, :integer, :null => false, :default => 0
  end

end
