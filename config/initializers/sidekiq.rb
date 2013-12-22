Sidekiq.configure_server do |config|
  config.redis = { :url => 'redis://0.0.0.0:6379/12', :namespace => 'cl1k' }
end

Sidekiq.configure_client do |config|
  config.redis = { :url => 'redis://0.0.0.0:6379/12', :namespace => 'cl1k' }
end
