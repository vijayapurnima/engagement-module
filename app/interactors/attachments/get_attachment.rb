require 'rest-client'
# The Class used for getting  attachment of corresponding Comm
#
# @rest_return Data [Object] Attachment Data Object with details
# @rest_return error_message [String] A message returned when attachment retrieval fails
class Attachments::GetAttachment
  include ExtendedInteractor

  # Call method used for retrieving the attachment associated with the id provided
  # Calls File Service to retrieve Attachment details
  #
  # @rest_param id [Integer] The id of the Attachment
  # @rest_param current_user [User] The User trying to delete
  # @rest_param comm_id [Integer] The Comm ID to which attachment is associated with
  # @rest_param service_name [String] Service name of Comm
  #
  # @rest_return Data [Object] Data Object with details
  # @rest_return error_message [String] A message returned when Attachment retrieval fails
  def call
    after_check do
      response = RestClient.get(
        SystemConfig.get('comm/host') + "/attachments/#{context[:id]}",
        params: {
          service_name: ApplicationController::SERVICE_NAME + (context[:current_user].service_name || ''),
          comm_id: context[:comm_id],
          user_id: context[:current_user][:id],
          recipient_type: 'User',
          recipient_id: context[:current_user][:id],
          which: 'file'
        }
      )
      context[:data] = response.body if response.code == 200
    rescue RestClient::Exception => e
      puts e.message, e.response
      Sentry.capture_exception(e)
      context.fail!(message: 'attachment.download_error')
    end
  end

  # Checks for id prior to attachment retrieval
  #
  # @return [Object,nil] Returns an Error Object if check fails else nil
  def check_context
    context.fail!(message: 'attachment.missing_identifier') unless context[:id]
  end
end
