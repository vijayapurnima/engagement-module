class RestrictionsController < ApplicationController

  # methods that require an authentication
  before_action :require_auth, only: [:index]


  # The Endpoint used to retrieve all EDOs
  #
  # @rest_url /restrictions
  # @rest_action GET
  #
  # @return [JSON]
  # @rest_return Restrictions [Array] Array of Restrictions with details
  # @rest_return error_message [String] A message returned when retrieval of Restrictions fails
  def index
    @restrictions = Rails.cache.fetch("presentation/controllers/restrictions/index", expires_in: 12.hours) do
      Restriction.distinct.select(:group_id)
    end
  end
end
