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
  after_update :create_update_activity


  def edited?
    created_at != updated_at
  end

  def timestamp
    return created_at if !edited?
    return updated_at
  end

  def create_update_activity
    if self.text_changed?
      self.create_activity({key: AppointmentMessageUpdateActivity::KEY, 
                            owner:self.user,
                            private: true,
                            parameters: {old_text: self.text_was}})
    end
  end

end
