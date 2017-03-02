class Resume < ApplicationRecord
  # Extensions
  dragonfly_accessor :file

  # Associations
  belongs_to :user

  # Validations
  validates_presence_of :user
  validates_presence_of :file
  validates_size_of :file, maximum: 5.megabytes
end
