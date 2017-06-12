class InviteSerializer < ActiveModel::Serializer
  attributes :id, :input, :viewed_on, :slug, :text
  has_one :user
end
