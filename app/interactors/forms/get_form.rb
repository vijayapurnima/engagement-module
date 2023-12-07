require 'rest-client'
# The Class used for getting  details of corresponding Form
#
# @rest_return Form [Object] Form Object with details
# @rest_return error_message [String] A message returned when Form retrieval fails
class Forms::GetForm
  include ExtendedInteractor

  # Call method used for retrieving the Form associated with the id provided
  # Calls Form Service to retrieve Form data
  #
  # @rest_param id [Integer] The id of the Form
  #
  # @rest_return Form [Object] Form Object with details
  # @rest_return error_message [String] A message returned when Form retrieval fails
  def call
    after_check do
      service_name = ApplicationController::SERVICE_NAME
      service_name += (context[:current_user].service_name || '') if context[:current_user]

      response = RestClient.get(
        SystemConfig.get('form/host') + "/forms/#{context[:id]}?service_name=#{context[:service_name] || service_name}",
        params: { access_type: context[:access_type] }
      )

      context[:form] = JSON.parse(response, symbolize_names: true) if response.code == 200
    rescue RestClient::Exception => e
      puts e.message, e.response
      Sentry.capture_exception(exception)
      context.fail!(message: 'form.get_error')
    end
  end

  # Checks for id prior to form retrieval
  #
  # @return [Object,nil] Returns an Error Object if check fails else nil
  def check_context
    context.fail!(message: 'form.missing_identifier') unless context[:id]
  end
end
