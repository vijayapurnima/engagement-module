# The Class used for creating membership for user with corresponding EDO
#
# @rest_return Membership [EdoMembership] Membership Object with membership role,status
# @rest_return error_message [String] A message returned when edo_membership creation fails
class Edos::CreateEdoMembership
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
      membership = EdoMembership.new(user: context[:user],group_id: context[:group_id], role: context[:role])
      membership.assign_attributes(invited_by: context[:invited_by]) unless context[:invited_by].nil?
      if membership.save!
        membership.reload
        context[:membership] = membership
      end
    end
  end

  # Checks for edo_id and user whose membership need to be created prior to Membership creation
  #
  # @return [Object,nil] Returns an Error Object if check fails else nil
  def check_context
    if !context[:group_id]
      context.fail!(message: "EDO not provided")
    elsif !context[:user]
      context.fail!(message: "User not provided")
    end
  end
end
