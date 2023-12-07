# The Class used for updating memberships for users with corresponding EDO
#
# @rest_return Membership [EdoMembership] Membership Object with membership role,status
# @rest_return error_message [String] A message returned when edo_membership creation fails
class Edos::UpdateEdoMemberships
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

      group = Group.cached_find(context[:id])

      if context[:users].length > 0
        context[:users].each do |user|
          if User.exists?(id: user[:id], email: user[:email])
            if EdoMembership.exists?(id: user[:id], group_id: group.id)
              membership = EdoMembership.find(user_id: user[:id])
              membership.assign_attributes(role: user[:role])
              membership.save!
            else
              edo_membership = Edos::CreateEdoMembership.call(group_id: group.id, user: user, role: user[:role])
              context.fail!(message: 'edo_membership.create_error') unless edo_membership.success?

            end
          end
        end
      end
    end
  end

  # Checks for current_user prior to Memberships updation
  #
  # @return [Object,nil] Returns an Error Object if check fails else nil
  def check_context
    if context[:users].nil?
      context.fail!(message: 'edo_membership.user_missing')
    elsif !context[:id] || Group.exists?(context[:id])
      context.fail!(message: 'edo_membership.edo_missing')
    end
  end
end
