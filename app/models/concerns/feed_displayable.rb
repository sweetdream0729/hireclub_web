module FeedDisplayable
  extend ActiveSupport::Concern

  included do
    has_many :likes, class_name: "Like", as: :likeable, dependent: :destroy
  end

  def feed_display_class
    self.class.name.downcase
  end
end
