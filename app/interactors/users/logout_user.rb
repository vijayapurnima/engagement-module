# The Class used for logging out from the account
# Calls Auth Service for deleting the auth_session corresponding to auth_token
#
# @rest_return response [Object] Response Object with status 200 after successful deletion
# @rest_return error_message [String] A message returned when user logout function fails
class Users::LogoutUser
  include ExtendedInteractor

  # Call method used for logging out the user from the session created
  # Calls Auth Service to delete auth_token if the auth_token is valid
  #
  # @rest_param auth_token [String] The auth_token of the user
  #
  # @rest_return response [Object] Response Object with status 200 after successful deletion
  # @rest_return error_message [String] A message returned when logout function fails
  def call
    after_check do
      service_name = ApplicationController::SERVICE_NAME + (context[:current_user].service_name || '')

      begin
        response = RestClient.delete(
          SystemConfig.get('auth/host') + "/auth_session?token=#{context[:auth_token]}&service_name=#{service_name}"
        )
      rescue RestClient::Exception => e
        puts e.message, e.response
        Sentry.capture_exception(e)
        context.fail! message: 'auth.no_token', status: :unprocessable_entity
      end
    end
  end

  # Checks for auth_token prior to User de-authentication
  #
  # @return [Object,nil] Returns an Error Object if check fails else nil
  def check_context
    if context[:auth_token].nil?
      context.fail!(message: 'auth.no_token')
    elsif context[:current_user].nil?
      context.fail!(message: 'user.not_exists')
    end
  end
end
