require 'rest-client'
# The Class used for Creating Form for corresponding Comm of EDO
#
# @rest_return Form [Object] Form Object with details
# @rest_return error_message [String] A message returned when Form creation failed
class Forms::CreateForm
  include Interactor

  # Call method used for creating the Form associated with the EDO provided
  # Calls Forms Service to create Form
  #
  # @rest_param params [Object] The parameters used for Form creation
  #
  # @rest_return Form [Object] Form Object  with details
  # @rest_return error_message [String] A message returned when Form creation fails
  def call
    service_name = ApplicationController::SERVICE_NAME + (context[:service] || '')
    response = RestClient.post(
      SystemConfig.get('form/host') + '/forms',
      { form: context[:form_details], service_name: service_name }
    )
    context[:form] = JSON.parse(response) if response.code == 201
  rescue RestClient::Exception => e
    puts e.message, e.response
    Sentry.capture_exception(e)
    context.fail!(message: 'form.create')
  end
end
