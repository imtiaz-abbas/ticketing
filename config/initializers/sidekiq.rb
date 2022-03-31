Sidekiq.configure_server do |config|
  config.redis = { url: ENV.fetch("SIDEKIQ_REDIS_URL") { "redis://localhost:6379/0" } }
  Rails.logger = Sidekiq.logger
  ActiveRecord::Base.logger = Sidekiq.logger
  ActionMailer::Base.logger = Sidekiq.logger
end
