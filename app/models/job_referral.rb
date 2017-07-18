class JobReferral < ApplicationRecord
  # Associations
  belongs_to :sender, class_name: 'User'
  belongs_to :user
  belongs_to :job
end
