class EmailList < ApplicationRecord
  # Associations
  has_many :email_list_members, inverse_of: :email_list, dependent: :destroy
  has_many :users, through: :email_list_members

  # Validations
  validates :name, presence: true, uniqueness: { case_sensitive: false }


  def add_user(user)
    member = email_list_members.where(user: user).first_or_initialize
    member.email = user.email
    member.save
  end

  def self.get_all_users
    self.where(name: 'All Users').first_or_create()
  end

  def self.add_confirmed_users_to_all
    all_users = self.get_all_users
    User.confirmed.find_each do |user|
      all_users.add_user(user)
    end
  end
end
