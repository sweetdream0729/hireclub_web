module Admin::PlacementAdmin
  extend ActiveSupport::Concern

  included do
    rails_admin do

      list do
        field :id
        field :placeable
        field :start_time
        field :end_time
        field :tags_list do
          label "Tags"
        end
        field :priority
        field :created_at
        field :updated_at
      end

      edit do
        field :placeable
        field :start_time
        field :end_time
        field :tags_list
        field :priority
      end
    end
  end
end
