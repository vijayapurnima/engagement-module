class AttachmentsController < ApplicationController

  # methods that require an admin role
  before_action :require_admin_role


  # The Endpoint used to create Attachment
  #
  # @rest_url /attachments/attachment
  # @rest_action POST
  # @rest_param attachment_params [Object] The attachment params used for creating attachment
  # @rest_param current_user [User] User who is accessing this call for creating attachment
  #
  # @return [JSON]
  # @rest_return Attachment [Object] Attachment Object with details
  # @rest_return error_message [String] A message returned when Creation of Attachment fails
  def create
    result = Attachments::CreateAttachment.call(attachment_params:params,current_user: current_user)
      if result.success?
        @attachment = result.attachment
        render 'attachments/create'
      else
        render_interactor_error result
      end
  end

  # The Endpoint which will get the Attachment details
  #
  # @rest_url /attachments/id
  # @rest_action GET
  # @rest_param id [Integer] The ID of the attachment that need to be retrieved
  # @rest_param comm_id [Integer] The ID of the Comm to which the attachment is associated with
  # @rest_param current_user [User] User who is accessing this call for retrieving attachment
  #
  # @return [JSON]
  # @rest_return Attachment [Object] Attachment Object with details
  # @rest_return error_message [String] A message only returned when retrieval of attachment failed
  def show
    result = Attachments::GetAttachment.call(id: params[:id], comm_id: params[:comm_id], current_user: current_user)
    if result.success?
      send_data result.data
    else
      render_interactor_error result
    end
  end

  # The Endpoint which will delete the Attachment
  #
  # @rest_url /attachments/id
  # @rest_action DELETE
  # @rest_param id [Integer] The ID of the attachment that need to be deleted
  # @rest_param comm_id [Integer] The ID of the Comm to which the attachment is associated with
  # @rest_param current_user [User] User who is accessing this call for deleting attachment
  #
  # @return [JSON]
  # @rest_return Response [Object] Returns the Response with status ok on successful deletion of attachment
  # @rest_return error_message [String] A message only returned when deletion of attachment failed
  def destroy
    result = Attachments::DeleteAttachment.call(id: params[:id], comm_id: params[:comm_id], current_user: current_user)
    if result.success?
      head :ok
    else
      render_interactor_error result
    end

  end


end
