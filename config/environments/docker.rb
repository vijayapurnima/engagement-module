Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Code is not reloaded between requests.
  config.cache_classes = true

  # Eager load code on boot. This eager loads most of Rails and
  # your application in memory, allowing both threaded web servers
  # and those relying on copy on write to perform better.
  # Rake tasks automatically ignore this option for performance.
  config.eager_load = true

  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local       = false

  result = SystemConfig.get_raw("/#{ENV['ENVIRONMENT']}/cache/host")

  if result.nil?
    config.action_controller.perform_caching = false
  else
    config.action_controller.perform_caching = true
    config.cache_store = :redis_store, result
  end

  # Attempt to read encrypted secrets from `config/secrets.yml.enc`.
  # Requires an encryption key in `ENV["RAILS_MASTER_KEY"]` or
  # `config/secrets.yml.key`.
  config.read_encrypted_secrets = true

  # Disable serving static files from the `/public` folder by default since
  # Apache or NGINX already handles this.
  config.public_file_server.enabled = false

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # Use the lowest log level to ensure availability of diagnostic information
  # when problems arise.
  config.log_level = :debug

  # Prepend all log lines with the following tags.
  config.log_tags = [ :request_id ]

  # Use a different cache store in production.
  # config.cache_store = :mem_cache_store

  # Use a real queuing backend for Active Job (and separate queues per environment)
  # config.active_job.queue_adapter     = :resque
  # config.active_job.queue_name_prefix = "licence_#{Rails.env}"
  config.action_mailer.perform_caching = false


  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation cannot be found).
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners.
  config.active_support.deprecation = :notify

  # Use default logging formatter so that PID and timestamp are not suppressed.
  config.log_formatter = ::Logger::Formatter.new

  logger           = ActiveSupport::Logger.new(STDOUT)
  logger.formatter = config.log_formatter
  config.logger    = ActiveSupport::TaggedLogging.new(logger)

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false

  config.lograge.formatter = Lograge::Formatters::Graylog2.new
  config.logger = GELF::Logger.new(
    'graylog.aws.strategenics.io',
    12_201,
    'WAN',
    {
      facility: "EDO#{'-Jobs' if ENV['JOBWORKER']}",
      application_name: 'EconomX',
      environment: ENV['ENVIRONMENT'],
      protocol: GELF::Protocol::TCP
    }
  )

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = JSON.parse(SystemConfig.get_raw("/#{ENV['ENVIRONMENT']}/edo/mail_settings")).symbolize_keys

  config.action_mailer.default_url_options = JSON.parse(SystemConfig.get_raw("/#{ENV['ENVIRONMENT']}/edo/mail/default_url_options")).symbolize_keys

  config.action_mailer.default_options = JSON.parse(SystemConfig.get_raw("/#{ENV['ENVIRONMENT']}/edo/mail/default_options")).symbolize_keys
end
