# frozen_string_literal: true
sentry_dsn = ENV.fetch('SENTRY_DSN', nil)

if sentry_dsn
  Sentry.init do |config|
    config.dsn                              = sentry_dsn
    config.enabled_environments             = %w[development beta production staging docker]

    # Overwrite RAILS_ENV
    sentry_env =
      case ENV.fetch('ENVIRONMENT', Rails.env)
      when 'dev'
        'development'
      when 'prod'
        'production'
      else
        ENV.fetch('ENVIRONMENT', Rails.env)
      end

    config.environment = sentry_env

    config.sidekiq.report_after_job_retries = true if defined? Sidekiq
    config.breadcrumbs_logger               = [
      :active_support_logger,
      :http_logger
    ]
  end
end

