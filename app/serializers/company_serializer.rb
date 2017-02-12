class CompanySerializer < ActiveModel::Serializer
  attributes :id, :name, :slug, :avatar_uid, :logo_uid, :twitter_url, :facebook_url, :instagram_url, :angellist_url, :website_url, :tagline
end
