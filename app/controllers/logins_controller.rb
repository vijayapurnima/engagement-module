class LoginsController < ApplicationController

  # Authentication is not required for these methods
  skip_before_action :require_auth, only: [:login]


  # The Endpoint used for user to login to EDO Connect
  #
  # @rest_url /logins
  # @rest_action GET
  # @rest_param username [String] The email of the user with domain used to login
  # @rest_param password [String] Password for the EDO account used for login
  #
  # @return [JSON]
  # @rest_return User [User] User Object with session created
  # @rest_return error_message [String] A message returned when login function fails
  def login
    result = Users::LoginUser.call(username: params[:username], password: params[:password], group_id: params[:group_id])
    if result.success?
      @data=result.data
      @user = GlobalID::Locator.locate result.user_ref
      session[:current_user_id] = @user.id
    else
      render_interactor_error result
    end
  end


  # The Endpoint used for user to logout from EDO Connect
  #
  # @rest_url /logins/user_id
  # @rest_action GET
  # @rest_param user_id [Integer] Id of the user whose session need to be deleted
  #
  # @return [JSON]
  # @rest_return Response [Object] Returns the Response with status ok on successful deletion of user session
  # @rest_return error_message [String] A message returned when user session deletion failed
  def logout
    @current_user = current_user
    result = Users::LogoutUser.call(auth_token: request.headers['HTTP_AUTHORIZATION'] || request.headers['HTTP_AUTHENTICATION'],current_user:@current_user)
    if result.success?
      reset_session
      head :ok
    else
      render_interactor_error result
    end
  end


  # The Endpoint used to get the user based on the token
  #
  # @rest_url /logins/token
  # @rest_action GET
  #
  # @return [JSON]
  # @rest_return User [User] Object with session details
  def token
    @user = current_user
    render 'logins/login'
  end
end