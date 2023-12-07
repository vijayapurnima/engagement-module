require 'rest-client'

# The Class used for verifying registered user with the code provided in mail
# Also stores password and makes the user active after successful verification
#
# @rest_return response [object] success response Object with 200 ok
# @rest_return error_message [String] A message returned when user verification fails
class Users::VerifyUser
  include ExtendedInteractor

  # The method used for verifying user with the code provided
  # Checks for user associated to Code
  # Calls Auth Service to store password associated to user
  # Makes the user status "active"
  # Sends welcome mail to user on success
  #
  # @rest_return User [User] User Object with session created
  # @rest_return error_message [String] A message returned when user verification or auth_service call fails
  def call
    after_check do
      user = User.find_by(code: context[:code])

      service_name = ApplicationController::SERVICE_NAME + (user.service_name || '')

      begin
        response = RestClient.post(
          SystemConfig.get('auth/host') + '/auth_user',
          { username: user.email, password: password, user_id: user.id, service_name: service_name }
        )
        if response.code == 201 || response.code == 200
          user.activate!
          user.assign_attributes(verified: true, code: nil, code_created_at: nil)
          user.save!
        end
      rescue RestClient::Exception => e
        puts e.message, e.response
        Sentry.capture_exception(e)
        context.fail! message: 'unknown', status: :unprocessable_entity
      end
    end
  end

  # Checks for code provided and any user associated to it for further processing
  # Check whether code is expired or can be used for verification
  #
  # @return [Object,nil] Returns an Error Object if check fails else nil
  def check_context
    if context[:code].nil?
      context.fail!(message: 'user.code_missing')
    elsif !User.exists?(code: context[:code]) || User.find_by(code: context[:code]).group_id != context[:group_id].try(:to_i)
      context.fail!(message: 'user.not_exists')
    elsif User.find_by(code: context[:code]).verification_link_expired?
      context.fail! message: 'user.code_expired', status: 412
    end
  end
end
