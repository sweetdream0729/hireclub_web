module UnpublishableActivity
  extend ActiveSupport::Concern

  included do
    before_destroy :unpublish_activities
  end
  
  def unpublish_activities
    Activity.where(trackable_id: self.id, trackable_type: self.class.name).update_all(published: false)
  end
end
