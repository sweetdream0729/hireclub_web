if Rails.application.secrets.redis_url.present?
  $redis = Redis.new(:url => Rails.application.secrets.redis_url)
end