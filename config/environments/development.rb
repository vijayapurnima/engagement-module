# frozen_string_literal: true

if ENV.fetch('CLOUD', nil)&.downcase == 'true'
  require_relative 'development/container'
else
  require_relative 'development/local'
end
