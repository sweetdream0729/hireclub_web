class EventSerializer < ActiveModel::Serializer
  attributes :id, :name, :slug, :start_time, :end_time, :description, :source_url, :image_uid, :venue
  has_one :user
end
