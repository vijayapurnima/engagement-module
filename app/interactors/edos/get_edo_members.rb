require 'rest-client'
# The Class used for getting members of corresponding EDO
#
# @rest_return EDO [Object] Edo Object with details
# @rest_return error_message [String] A message returned when Edo retrieval fails
class Edos::GetEdoMembers
  include ExtendedInteractor

  # Call method used for retrieving the EDO associated with the id provided
  # Calls ECX Presentation Service to retrieve EDO members details
  #
  # @rest_param id [Integer] The id of the EDO
  #
  # @rest_return EDO [Object] EDO Object with details with/without members based on with_organization flag
  # @rest_return error_message [String] A message returned when group retrieval fails
  def call
    after_check do
      group = Group.cached_find(context[:id])

      begin
        response = RestClient.get(
          "#{SystemConfig.get('ecx/host')}/business/groups/#{group.group_id}/members",
          { ECX_API: SystemConfig.get('ecx/api_key'),
            params: { with_organisation: context[:with_organization] } }
        )

        context[:edo] = JSON.parse(response, symbolize_names: true) if response.code == 200
      rescue RestClient::Exception => e
        puts e.message, e.response
        Sentry.capture_exception(e)
        case e.class
        when RestClient::Unauthorized 
          context.fail!(message: 'Unauthorized or Signed Out', status: 401)
        when RestClient::ExceptionWithResponse
          context.fail!(message: JSON.parse(e.response))
        else
          context.fail!(message: 'edo.members_get_error')
        end
      end
    end
  end

  # Checks for group_id prior to edo/group retrieval
  #
  # @return [Object,nil] Returns an Error Object if check fails else nil
  def check_context
    context.fail!(message: 'edo.missing_identifier') unless context[:id] || Group.exists?(context[:id])
  end
end
