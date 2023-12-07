HealthCheck.setup do |config|
  config.standard_checks = %w(database migrations)
end