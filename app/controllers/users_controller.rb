class UsersController < ApplicationController

  # admin role is not required for these methods
  before_action :require_auth,:require_admin_role, only: [:index]


  # The Endpoint used to retrieve all Users corresponding to User of EDO based on which property
  #
  # @rest_url /users
  # @rest_action GET
  # @rest_param which [String] The which type of users need to be retrieved
  #
  # @return [JSON]
  # @rest_return Users [Array] Array of User Objects with details
  # @rest_return error_message [String] A message returned when retrieval of Users of corresponding EDO fails
  def index
    @users = Rails.cache.fetch("presentation/controllers/users/#{params[:which]}/#{current_user.group.id}", expires_in: 12.hours) do
      case params[:which]
        when 'active'
          User.only_active.by_edo(current_user.group.id)
        when 'admins'
          User.only_active.by_admin_role(current_user.group.id)
        when 'all'
          User.by_edo(current_user.group.id)
      end
    end
  end


  # The Endpoint used for user to register in EDO Connect
  #
  # @rest_url /users/register
  # @rest_action POST
  # @rest_param email [String] The email of the user used to register
  # @rest_param name [String] Name of teh user
  #
  # @return [JSON]
  # @rest_return Response [Object] Response Object with status ok
  # @rest_return error_message [String] A message returned when creation function fails
  def create
    result = Users::CreateUser.call(register_params)

    if result.success?
      head :ok
    else
      render_interactor_error result
    end
  end


  # The Endpoint used for verifying the registered user in EDO Connect
  #
  # @rest_url /users/verify
  # @rest_action GET
  # @rest_param email [String] The email of the user used to register
  # @rest_param name [String] Name of teh user
  #
  # @return [JSON]
  # @rest_return Response [Object] Response Object with status ok
  # @rest_return error_message [String] A message returned when creation function fails
  def verify
    result = Users::VerifyUser.call(verify_params)

    if result.success?
      head :ok
    else
      render_interactor_error result
    end

  end


  # The Endpoint used for sending verification link to email provided in EDO Connect
  #
  # @rest_url /users/resend_link?email=
  # @rest_action POST
  # @rest_param email [String] The email of the user used to register
  #
  # @return [JSON]
  # @rest_return Response [Object] Response Object with status ok
  # @rest_return error_message [String] A message returned when creation function fails
  def resend_link
    result = Users::ResendVerificationLink.call(email: params[:email], group_id: params[:group_id])

    if result.success?
      head :ok
    else
      render_interactor_error result
    end
  end


  # The Endpoint used for resetting password code for active user
  #
  # @rest_url /users/reset_password?email=
  # @rest_action POST
  # @rest_param email [String] The email of the user used to register
  #
  # @return [JSON]
  # @rest_return Response [Object] Response Object with status ok
  # @rest_return error_message [String] A message returned when resetting password code fails
  def reset_password
    result = Users::ResetPassword.call(email: params[:email], group_id: params[:group_id])

    if result.success?
      head :ok
    else
      render_interactor_error result
    end
  end

  # The Endpoint used for changing the existing password with new password provided
  #
  # @rest_url /users/change_password
  # @rest_action PUT
  # @rest_param password [String] The new password of the user used to access the account
  # @rest_param code [String] The code of the user for resetting the password
  #
  # @return [JSON]
  # @rest_return Response [Object] Response Object with status ok
  # @rest_return error_message [String] A message returned when password change function fails
  def change_password
    result = Users::ChangePassword.call(verify_params)

    if result.success?
      head :ok
    else
      render_interactor_error result
    end
  end


  private

  # Method which validates the incoming parameters with the list inside it
  # Params which are not part of below will be excluded from being passed
  #
  # @rest_url /users/register_params
  # @rest_action GET
  #
  # @rest_return Params [Object] Object with require parameters
  def register_params
    params.require(:user).permit(:email, :name,:group_id)
  end

  # Method which validates the incoming parameters with the list inside it
  # Params which are not part of below will be excluded from being passed
  #
  # @rest_url /users/verify_params
  # @rest_action GET
  #
  # @rest_return Params [Object] Object with require parameters
  def verify_params
    params.require(:verify).permit(:password, :code, :group_id)
  end

end
