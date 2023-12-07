# The Class used for resetting verification code for registered  user who hasn't completed verification
#
# @rest_return response [object] success response Object with 200 ok
# @rest_return error_message [String] A message returned when code reset of user fails
class Users::ResetCode
  include ExtendedInteractor

  # The method used for resetting code for user
  #
  # @rest_return User [User] User Object with new code
  # @rest_return error_message [String] A message returned when code reset fails
  def call
    after_check do
      # set a new simple code on the user and set the code_created_at to the current time
      context[:user].assign_attributes(code: User.new_simple_code, code_created_at: Time.now)
      context[:user].save!
    end
  end

  # Checks for user whose code need to be set
  #
  # @return [Object,nil] Returns an Error Object if check fails else nil
  def check_context
    unless context[:user]
      context.fail!(message: 'user.not_exists')
    end
  end
end
