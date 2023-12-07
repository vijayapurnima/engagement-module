require 'rest-client'
# The Class used for deleting comm corresponding to user
#
# @rest_return Response [Object] Response Object with status 200
# @rest_return error_message [String] A message returned when comm deletion fails
class Comms::DeleteComm
  include ExtendedInteractor

  # Call method used for deleting the comm associated with the id provided
  # Calls Comms Service to destroy Comm
  #
  # @rest_param id [Integer] The id of the Comm
  # @rest_param current_user [User] The User trying to delete
  #
  # @rest_return Response [Object] Response Object with status 200
  # @rest_return error_message [String] A message returned when comm deletion fails
  def call
    after_check do
      response = RestClient.delete(
        SystemConfig.get('comm/host') + "/comms/#{context[:id]}?service_name=#{ApplicationController::SERVICE_NAME + (context[:current_user].service_name || '')}"
      )
    rescue RestClient::Exception => e
      puts e.message, e.response
      Sentry.capture_exception(e)
      context.fail!(message: 'comms.destroy_error')
    end
  end

  # Checks for id prior to comm removal
  #
  # @return [Object,nil] Returns an Error Object if check fails else nil
  def check_context
    if context[:id].nil?
      context.fail!(message: 'comms.missing_identifier')
    elsif context[:current_user].nil?
      context.fail!(message: 'comms.user_not_provided')
    end
  end
end
