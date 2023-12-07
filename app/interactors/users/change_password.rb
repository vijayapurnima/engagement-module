require 'rest-client'
class Users::ChangePassword
  include ExtendedInteractor

  # The method used for setting  new password for the user associated to code provided
  # Checks for user associated to code with active status
  # Checks whether code expired or not
  # Calls Auth service to set new password to the user
  #
  # @rest_return User [User] User Object with new password
  def call
    after_check do
      user = User.find_by(code: context[:code])

      service_name=ApplicationController::SERVICE_NAME+(user.service_name || "")

      begin
        response = RestClient.put(
            SystemConfig.get('auth/host') + "/auth_user",
            {username: user.email, password: context[:password], service_name: service_name}
        )
        if response.code == 201
          user.code = nil
          user.code_created_at = nil
          user.save!
        end
      rescue RestClient::Exception => exception
        context.fail! message: 'auth.invalid_credentials', status: :unprocessable_entity
      end

    end
  end

  # Checks for code provided and any user associated to it with active status for further processing
  # Check whether code is expired or can be used for verification
  #
  # @return [Object,nil] Returns an Error Object if check fails else nil
  def check_context
    if !context[:code]
      context.fail!(message: "user.code_mismatch")
    elsif !context[:password]
      context.fail!(message: "user.password_required")
    elsif !User.exists?(code: context[:code],status:'active')
      context.fail!(message: "user.not_exists")
    elsif User.find_by(code: context[:code]).code_expired?
      context.fail!(message: "user.code_expired")
    end
  end
end
