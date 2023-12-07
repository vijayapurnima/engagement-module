require 'rest-client'
# The Class used for getting forms of particular EDO
#
# @rest_return Forms [Array<Object>] Array of Form Objects with details
# @rest_return error_message [String] A message returned when Forms retrieval fails
class Forms::GetFormsByEdo
  include ExtendedInteractor

  # Call method used for retrieving the Forms associated with the service_name provided
  # Calls Form Service to retrieve Forms
  #
  # @rest_param service_name [String] The service name of Forms
  #
  # @rest_return Forms [Array<Object>] Array of Form Objects with details
  # @rest_return error_message [String] A message returned when Forms retrieval fails
  def call
    service_name = ApplicationController::SERVICE_NAME + (context[:service_name] || '')

    begin
      response = RestClient.get(
        SystemConfig.get('form/host') + "/forms?service_name=#{service_name}",
        params: { access_type: context[:access_type] }
      )
      context[:forms] = JSON.parse(response) if response.code == 200
    rescue RestClient::Exception => e
      puts e.message, e.response
      Sentry.capture_exception(e)
      context.fail!(message: 'forms.get_error')
    end
  end
end
