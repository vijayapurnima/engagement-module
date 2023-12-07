require 'rest-client'
# The Class used for deleting attachment corresponding to Comm
#
# @rest_return Response [Object] Response Object with status 200
# @rest_return error_message [String] A message returned when attachment deletion fails
class Attachments::DeleteAttachment
  include ExtendedInteractor

  # Call method used for deleting the attachment associated with the id provided
  # Calls File Service to destroy Attachment
  #
  # @rest_param id [Integer] The id of the Attachment
  # @rest_param current_user [User] The User trying to delete
  # @rest_param comm_id [Integer] The Comm ID to which attachment is associated with
  # @rest_param service_name [String] Service name of Comm
  #
  # @rest_return Response [Object] Response Object with status 200
  # @rest_return error_message [String] A message returned when attachment deletion fails
  def call
    after_check do
      response = RestClient.delete(
        SystemConfig.get('comm/host') + "/attachments/#{context[:id]}?service_name=#{ApplicationController::SERVICE_NAME + (context[:current_user].service_name || '')}&user_id=#{context[:current_user][:id]}&comm_id=#{context[:comm_id]}"
      )
      if response.code == 200
      end
    rescue RestClient::Exception => e
      puts e.message, e.response
      Sentry.capture_exception(e)
      context.fail!(message: 'attachment.destroy_error')
    end
  end

  # Checks for id prior to attachment removal
  #
  # @return [Object,nil] Returns an Error Object if check fails else nil
  def check_context
    context.fail!(message: 'attachment.missing_identifier') unless context[:id]
  end
end
