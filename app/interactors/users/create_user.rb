# The Class used for creating user with the membership associated
# Sends verification mail to user after successful user and membership creation
#
# @rest_return User [User] User Object with session created
# @rest_return error_message [String] A message returned when user authentication function fails
class Users::CreateUser
  include ExtendedInteractor


  # The method used for creating user with the membership associated
  # Calls CreateEdoMembership Class for creating a membership to the user with EDO
  # Sends verification mail to user after successful user and membership creation
  #
  # @rest_return User [User] User Object with session created
  # @rest_return error_message [String] A message returned when user authentication function fails
  def call
    after_check do
      unless User.exists?(email: context[:email].downcase)
        user = User.new(email: context[:email].downcase, code: User.new_simple_code, code_created_at: Time.now, name: context[:name], user_type: 'user')

        user.validate_user_data(context[:group_id])

        if user.save!
          edo_membership = Edos::CreateEdoMembership.call(group_id: context[:group_id], user_ref: user.try(:to_gid), role: 'admin')
          context[:membership] = GlobalID::Locator.locate edo_membership.membership

          UsersMailer.send_verification_email(user).deliver_later!
          context[:user] = user
        end
      end
    end
  end


  # Checks for user associated with provided email prior to User creation
  #
  # @return [Object,nil] Returns an Error Object if check fails else nil
  def check_context
    if context[:email].nil?
      context.fail!(message: 'user.email_required')
    elsif User.exists?(email: context[:email].downcase)
      user = User.find_by(email: context[:email].downcase)
      UsersMailer.send_alert_on_registration(user).deliver_later!
    end
  end
end
