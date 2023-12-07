require 'rest-client'
# The Class used for getting market request details
#
# @rest_return market_request [Object] Market_request Object with details
# @rest_return error_message [String] A message returned when market_request retrieval fails
class MarketRequests::GetMarketRequest
  include ExtendedInteractor

  # Call method used for retrieving the market_request associated with the id provided
  # Calls MR Service to retrieve market_request with details
  #
  # @rest_param id [Integer] The id of the market request
  #
  # @rest_return Market Request [Object] Market request Object with details
  # @rest_return error_message [String] A message returned when MarketRequest retrieval fails
  def call
    after_check do
      response = RestClient.get(
        SystemConfig.get('mr/host') + "/market_requests/#{context[:id]}",
        params: { without_elements: context[:without_elements] }
      )
      context[:market_request] = JSON.parse(response, symbolize_names: true) if response.code == 200
    rescue RestClient::Exception => e
      puts e.message, e.response
      Sentry.capture_exception(e)
      context.fail!(message: JSON.parse(e.response, symbolize_names: true)[:description])
    end
  end

  # Checks for id prior to market_request retrieval
  #
  # @return [Object,nil] Returns an Error Object if check fails else nil
  def check_context
    context.fail(message: 'market_request.missing_identifier') unless context[:id]
  end
end
