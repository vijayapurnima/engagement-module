require 'rest-client'
# The Class used for getting EDO member details
#
# @rest_return Organization [Object] Organization Object with details
# @rest_return error_message [String] A message returned when Organization retrieval fails
class Organizations::GetOrganization
  include ExtendedInteractor

  # Call method used for retrieving the Organization associated with the id provided
  # Calls ECX Presentation Service to retrieve Organization with details
  #
  # @rest_param id [Integer] The id of the Organization
  #
  # @rest_return Organization [Object] Organization Object with details
  # @rest_return error_message [String] A message returned when organization retrieval fails
  def call
    after_check do
      response = RestClient.get(
        SystemConfig.get('ecx/host') + "/business/profile/get_organization",
        params: {
          id: context[:id],
          columns: context[:columns],
          access_level: context[:access_level],
          ECX_API: SystemConfig.get('ecx/api_key')
        }
      )
      context[:organization] = JSON.parse(response, symbolize_names: true) if response.code == 200
    rescue RestClient::Exception => e
      puts e.message, e.response
      Sentry.capture_exception(e)
      case e.class
      when RestClient::Unauthorized
        context.fail!(message: 'Unauthorized or Signed Out', status: 401)
      when RestClient::ExceptionWithResponse
        context.fail!(message: JSON.parse(e.response))
      else
        context.fail!(message: 'organization.get_error')
      end
    end
  end

  # Checks for id prior to organization retrieval
  #
  # @return [Object,nil] Returns an Error Object if check fails else nil
  def check_context
    context.fail!(message: 'organization.missing_identifier') unless context[:id]
  end
end
