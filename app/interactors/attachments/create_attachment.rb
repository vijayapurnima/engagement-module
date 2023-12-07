require 'rest-client'
# The Class used for creating attachment corresponding to Comm
#
# @rest_return Attachment [Object] Attachment Object with details
# @rest_return error_message [String] A message returned when attachment creation fails
class Attachments::CreateAttachment
  include ExtendedInteractor

  # Call method used for creating the attachment associated with the file and linked details provided
  # Calls File Service to create Attachment with details provided
  #
  # @rest_param file [Object] The file object which need to be stored
  # @rest_param attachment_type [String] The type of file
  # @rest_param linked_id [Integer] The ID to which file is linked to
  # @rest_param linked_type [String] type to which file is linked to
  # @rest_param User [User] User who is trying to create the attachment
  #
  # @rest_return Attachment [Object] Attachment Object with details
  # @rest_return error_message [String] A message returned when Attachment creation fails
  def call
    after_check do
      response = RestClient.post(
        SystemConfig.get('comm/host') + '/attachments',
        { file: context[:attachment_params][:file],
          attachment_type: context[:attachment_params][:attachment_type],
          linked_id: context[:attachment_params][:linked_id],
          linked_type: context[:attachment_params][:linked_type],
          service_name: ApplicationController::SERVICE_NAME + (context[:current_user].service_name || ''),
          user_id: context[:current_user][:id] }
      )
      context[:attachment] = JSON.parse(response, symbolize_keys: true)[:attachment] if response.code == 200
    rescue RestClient::Exception => e
      puts e.message, e.response
      Sentry.capture_exception(e)
      context.fail!(message: 'attachment.create_error')
    end
  end

  # Checks for file,attachment_tye,linked_details prior to attachment creation
  # Validates the file size prior to creation call
  #
  # @return [Object,nil] Returns an Error Object if check fails else nil
  def check_context
    if !context[:attachment_params][:file] || !context[:attachment_params][:attachment_type] || !context[:attachment_params][:linked_id]
      context.fail!(message: 'attachment.missing_details')
    elsif Helpers::Attachments.size_exceeded?(context[:attachment_params][:file].content_type,
                                              context[:attachment_params][:file].size.to_i)
      context.fail!(message: 'attachment.file_too_large', status: :request_entity_too_large)
    end
  end
end
