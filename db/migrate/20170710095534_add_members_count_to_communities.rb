class AddMembersCountToCommunities < ActiveRecord::Migration

  def change
    add_column :communities, :members_count, :integer, :null => false, :default => 0
  end

end
