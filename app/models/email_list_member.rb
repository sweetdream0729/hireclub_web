class EmailListMember < ApplicationRecord
  belongs_to :user
  belongs_to :email_list
  counter_culture :email_list, column_name: "members_count"

  # Validations
  validates :email_list, presence: true
  validates :email, presence: true, uniqueness: { scope: :email_list_id, case_sensitive: false }
  validates :user_id, uniqueness: { scope: :email_list_id }

  def user=(value)
    self.email = value.email
    super(value)
  end
end
