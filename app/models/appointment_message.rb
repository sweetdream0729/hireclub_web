class AppointmentMessage < ApplicationRecord
  include UnpublishableActivity
  include PublicActivity::CreateActivityOnce
  include PublicActivity::Model
  tracked only: [:create], owner: Proc.new{ |controller, model| model.user }, private: true
  nilify_blanks

  # Scopes
  scope :by_recent, -> {order(created_at: :desc)}
  scope :by_oldest, -> {order(created_at: :asc)}

  # Associations
  belongs_to :user
  belongs_to :appointment

  # Validations
  validates :user, presence: true
  validates :appointment, presence: true
  validates :text, presence: true


  def edited?
    created_at != updated_at
  end

  def timestamp
    return created_at if !edited?
    return updated_at
  end

  def create_update_activity
    if self.previous_changes.key?('text')
      self.create_activity({key: "appointment_message.edit", 
                            owner:self.user,
                            private: true,
                            parameters: {old_text: self.previous_changes[:text][0]}})
    end
  end

end
