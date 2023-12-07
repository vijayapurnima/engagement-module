class CommsController < ApplicationController

  # methods that require an admin role
  before_action :require_admin_role

  # methods that set comm prior to provided methods execution
  before_action :get_comm, only: [:show, :update, :destroy]

  # The Endpoint used to retrieve all Comms corresponding to User of EDO
  #
  # @rest_url /comms
  # @rest_action GET
  # @rest_param service_name [String] The name of the EDO whose Comms need to be retrieved
  #
  # @return [JSON]
  # @rest_return Comms [Array] Array of Comm Objects with details
  # @rest_return error_message [String] A message returned when retrieval of Comms of corresponding EDO fails
  def index

    result = Comms::GetComms.call(which: params[:which], current_user: current_user)

    if result.success?
      @comms = result.comms
    else
      render_interactor_error result
    end

  end

  # The Endpoint used to create Comm
  #
  # @rest_url /comms/comm
  # @rest_action POST
  # @rest_param comm_params [Object] The comm params used for creating Comm
  # @rest_param current_user [User] User who is accessing this call for creating comm
  #
  # @return [JSON]
  # @rest_return Comm [Object] Comm Object with details
  # @rest_return error_message [String] A message returned when Creation of Comm fails
  def create

    result = Comms::CreateComm.call(params: params[:comm], current_user: current_user)

    if result.success?
      @comm = result.comm
    else
      render_interactor_error result
    end
  end

  # The Endpoint used to update Comm
  #
  # @rest_url /comms/comm/id
  # @rest_action PUT
  # @rest_param comm_params [Object] The comm params used for updating Comm
  # @rest_param current_user [User] User who is accessing this call for updating comm
  #
  # @return [JSON]
  # @rest_return Comm [Object] Comm Object with details
  # @rest_return error_message [String] A message returned when updation of Comm fails
  def update
    result = Comms::UpdateComm.call(id: @comm[:id], params: params[:comm], current_user: current_user)

    if result.success?
      @comm = result.comm
      render 'comms/show'
    else
      render_interactor_error result
    end
  end

  # The Endpoint used to getting Comm
  #
  # @rest_url /comms/comm/:id
  # @rest_action GET
  # @rest_param ID [Integer] The comm ID used for retrieval of Comm
  # @rest_param current_user [User] User who is accessing this call for retrieving comm
  # Calls get_comm method for retrieving the comm
  #
  # @return [JSON]
  # @rest_return Comm [Object] Comm Object with details
  # @rest_return error_message [String] A message returned when retrieval of Comm fails
  def show
    render 'comms/show'
  end

  # The Endpoint which will delete the Comm
  #
  # @rest_url /comms/id
  # @rest_action DELETE
  # @rest_param id [Integer] The ID of the comm that need to be deleted
  # @rest_param current_user [User] User who is accessing this call for deleting comm
  #
  # @return [JSON]
  # @rest_return Response [Object] Returns the Response with status ok on successful deletion of comm
  # @rest_return error_message [String] A message only returned when deletion of comm failed
  def destroy
    result = Comms::DeleteComm.call(id: @comm[:id], current_user: current_user)

    if result.success?
      head :ok
    else
      render_interactor_error result
    end
  end


  # The Endpoint which will notify the Comm to it's members
  #
  # @rest_url /comms/notify_members/id
  # @rest_action POST
  # @rest_param id [Integer] The ID of the comm that need to be notified
  # @rest_param current_user [User] User who is accessing this call for notifying comm
  #
  # @return [JSON]
  # @rest_return Comm [Object] Comm Object with details
  # @rest_return error_message [String] A message only returned when notifying regarding comm failed
  def notify_members
    unless params[:id].nil?
      get_comm
      id=@comm['id']
    end
    result = Comms::SendComm.call(id: id || nil , params: params[:comm], current_user: current_user)

    if result.success?
      @comm = result.comm
      render 'comms/show'
    else
      render_interactor_error result
    end
  end


  private


  # Method which will get the Comm prior to all calls  which has id
  #
  # @rest_param id [Integer] The ID of the comm that need to be retrieved
  # @rest_param current_user [User] User who is accessing this call for comm operations
  #
  # @return [JSON]
  # @rest_return Comm [Object] Comm Object with details
  # @rest_return error_message [String] A message only returned when retrieving comm failed
  def get_comm
    result = Comms::GetComm.call(id: params[:id], current_user: current_user)

    if result.success?
      @comm = result.comm
    else
      render_interactor_error result
    end

  end



end
