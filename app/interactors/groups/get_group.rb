require 'rest-client'
# The Class used for getting  details of corresponding Group in Groups Table (group_id column)
#
# @rest_return Group [Object] Group Object with details
# @rest_return error_message [String] A message returned when group retrieval fails
class Groups::GetGroup
  include ExtendedInteractor

  # Call method used for retrieving the group associated with the id provided
  # Calls Business Service to retrieve Group details
  #
  # @rest_param id [Integer] The id of the Group
  #
  # @rest_return Group [Object] Group Object with details with/without members based on with_organization flag and columns required
  # @rest_return error_message [String] A message returned when Group retrieval fails
  def call
    after_check do
      response = RestClient.get(
        SystemConfig.get('ecx/host') + "/business/groups/#{context[:group_id]}",
        params: {
          with_organization: context[:with_organization],
          columns: context[:columns],
          ECX_API: SystemConfig.get('ecx/api_key')
        }
      )

      context[:group] = JSON.parse(response, symbolize_names: true) if response.code == 200
    rescue RestClient::Exception => e
      puts e.message, e.response
      Sentry.capture_exception(e)
      context.fail!(message: 'group.get_error')
    end
  end

  # Checks for id prior to edo/group retrieval
  #
  # @return [Object,nil] Returns an Error Object if check fails else nil
  def check_context
    context.fail!(message: 'group.missing_identifier') unless context[:group_id]
  end
end
