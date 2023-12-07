require 'rest-client'
# The Class used for getting  Comm
#
# @rest_return Comm [Object] Comm Data Object with details
# @rest_return error_message [String] A message returned when Comm retrieval fails
class Comms::GetComm
  include ExtendedInteractor

  # Call method used for retrieving the comm associated with the id provided
  # Calls Comms Service to retrieve Comm details
  #
  # @rest_param id [Integer] The id of the Comm
  #
  #
  # @rest_return Comm [Object] Comm Object with details
  # @rest_return error_message [String] A message returned when Comm retrieval fails
  def call
    after_check do
      response = RestClient.get(
        SystemConfig.get('comm/host') + "/comms/#{context[:id]}?service_name=#{ApplicationController::SERVICE_NAME + (context[:current_user].service_name || '')}"
      )
      context[:comm] = JSON.parse(response, symbolize_keys: true)[:comm] if response.code == 200
    rescue RestClient::Exception => e
      puts e.message, e.response
      Sentry.capture_exception(e)
      context.fail!(message: 'comms.get_error')
    end
  end

  # Checks for id prior to Comm retrieval
  #
  # @return [Object,nil] Returns an Error Object if check fails else nil
  def check_context
    context.fail!(message: 'comms.missing_identifier') unless context[:id]
  end
end
