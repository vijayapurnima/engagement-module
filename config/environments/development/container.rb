# frozen_string_literal: true

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = true

  # Do not eager load code on boot.
  config.eager_load = true

  # Show full error reports.
  config.consider_all_requests_local = false

  # Enable/disable caching. By default caching is disabled.
  if ENV['REDIS_URL']
    config.action_controller.perform_caching = true
    config.cache_store = :redis_store
  else
    config.action_controller.perform_caching = false
  end

  config.read_encrypted_secrets = true

  # Disable serving static files from the `/public` folder by default since
  # Apache or NGINX already handles this.
  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?

  # Use the lowest log level to ensure availability of diagnostic information
  # when problems arise.
  config.log_level = :debug

  # Prepend all log lines with the following tags.
  config.log_tags = [:request_id]

  config.action_mailer.perform_caching = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :notify

  # Use default logging formatter so that PID and timestamp are not suppressed.
  config.log_formatter = ::Logger::Formatter.new

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  config.serve_static_files = false

  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.delivery_method       = :smtp
  config.action_mailer.smtp_settings         = {
    address: ENV.fetch('ECX_MAIL_SERVER', 'localhost'),
    port: ENV.fetch('ECX_MAIL_PORT', 1025)
  }

  config.action_mailer.default_url_options = { host: ENV.fetch('ECX_DEFAULT_URL_OPTIONS', nil) }

  config.action_mailer.default_options = { from: ENV.fetch('ECX_MAIL_FROM', nil) }

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  # config.file_watcher = ActiveSupport::EventedFileUpdateChecker
  if ENV['RAILS_LOG_TO_STDOUT'].present?
    logger = ActiveSupport::Logger.new($stdout)
    logger.formatter = config.log_formatter
    config.logger    = ActiveSupport::TaggedLogging.new(logger)
  end

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false
end
