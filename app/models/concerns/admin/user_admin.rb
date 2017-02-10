module Admin::UserAdmin
  extend ActiveSupport::Concern

  included do
    rails_admin do
      
      weight -1000

      list do
        scopes [nil, :normal, :admin]
        
        field :id
        field :avatar do
          pretty_value do
            src = bindings[:view].model_image(bindings[:object], 200, 200)
            bindings[:view].tag(:img, { :src => src })
          end
        end
        field :email
        field :username
        field :name
        field :last_sign_in_at
        field :created_at
        field :updated_at
      end
    end
  end
end