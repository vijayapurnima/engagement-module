# The Class used for sending a verification code to registered email provided
#
# @rest_return response [object] success response Object with 200 ok
# @rest_return error_message [String] A message returned when user verification fails
class Users::ResendVerificationLink
  include ExtendedInteractor


  # The method used for sending  verification code to the email for the user associated to it
  # Checks for user associated to email
  # Check whether user is verified if exists
  # Resets the code for the user to send it to the user
  # sends mail with new verification code to the user's mail
  #
  # @rest_return User [User] User Object with new verification code created if not verified
  def call
    after_check do
      user = User.find_by(email: context[:email].downcase)

      unless (user.nil? || user.verified?) && user.group_id != context[:group_id].try(:to_i)
        result = Users::ResetCode.call(user_ref: user.try(:to_gid))
        if result.success?
          user.reload
          UsersMailer.send_verification_email(user).deliver_later!
        end
      end
    end
  end

  # Checks for email provided
  #
  # @return [Object,nil] Returns an Error Object if check fails else nil
  def check_context
    unless context[:email]
      context.fail!(message: 'user.email_required')
    end
  end
end