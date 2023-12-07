require 'rest-client'
# The Class used for getting Project details
#
# @rest_return Project [Object] Project Object with details
# @rest_return error_message [String] A message returned when Project retrieval fails
class Projects::GetProject
  include ExtendedInteractor

  # Call method used for retrieving the Project associated with the id provided
  # Calls ECX Presentation Service to retrieve Project with details
  #
  # @rest_param id [Integer] The id of the Project
  #
  # @rest_return Project [Object] Project Object with details
  # @rest_return error_message [String] A message returned when project retrieval fails
  def call
    after_check do
      response = RestClient.get(
        SystemConfig.get('ecx/host') + "/projects/#{context[:id]}",
        params: { columns: context[:columns] || nil },
        AUTHORIZATION: context[:authorization],
        ECX_API: SystemConfig.get('ecx/api_key')
      )
      context[:project] = JSON.parse(response, symbolize_names: true) if response.code == 200
    rescue RestClient::Exception => e
      puts e.message, e.response
      Sentry.capture_exception(e)
      context.fail!(message: 'project.get_error')
    end
  end

  # Checks for id prior to project retrieval
  #
  # @return [Object,nil] Returns an Error Object if check fails else nil
  def check_context
    context.fail(message: 'project.missing_identifier') unless context[:id]
  end
end
