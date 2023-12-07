require 'rest-client'

# The Class used for authenticating user credentials and creates an auth_token
# Calls Auth Service for creating the auth_session corresponding to user
#
# @rest_return User [User] User Object with session created
# @rest_return error_message [String] A message returned when user authentication function fails
class Users::LoginUser
  include ExtendedInteractor

  # Call method used for verifying the user credentials
  # Calls Auth Service to get auth_token if the credentials are valid
  #
  # @rest_param username [String] The email of the user with domain used to login
  # @rest_param password [String] Password for the EDO account used for login
  #
  # @rest_return User [User] User Object with session created
  # @rest_return error_message [String] A message returned when login function fails
  def call
    after_check do
      user = User.find_by(email: context[:username].downcase)
      # Check the user is a member of the group that is set on the frontend environment
      context.fail!(message: 'auth.invalid_credentials') if user.group_id != context[:group_id].try(:to_i)
      service_name = ApplicationController::SERVICE_NAME + (user.service_name || '')
      if user.verified?
        begin
          response = RestClient.post(
            SystemConfig.get('auth/host') + '/auth_session',
            { username: context[:username].downcase, password: context[:password], service_name: service_name }
          )
          if response.code == 201
            context[:data] = JSON.parse(response, symbolize_keys: true)
            context[:user_ref] = user.try(:to_gid)
          end
        rescue RestClient::Exception => e
          puts e.message, e.response
          Sentry.capture_exception(e)
          context.fail!(message: 'auth.invalid_credentials', status: :unprocessable_entity)
        end
      else
        context.fail!(message: 'user.unverified_user')
      end
    end
  end

  # Checks for username and password and user associated to both prior to User Authentication
  #
  # @return [Object,nil] Returns an Error Object if check fails else nil
  def check_context
    if !context[:username] || !context[:password]
      context.fail!(message: 'auth.missing_credentials')
    elsif !User.exists?(email: context[:username].downcase) || !User.find_by(email: context[:username].downcase).active?
      context.fail!(message: 'auth.invalid_credentials')
    end
  end
end
