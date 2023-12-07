require 'rest-client'
# The Class used for notifying Business users regarding Comm
#
# @rest_return Response [Object] Response Object with status 200
# @rest_return error_message [String] A message returned when notifying about comm failed
class Comms::NotifyUsers
  include ExtendedInteractor

  # Call method used for notifying users regarding the Comm associated
  # Calls ECX presentation Service to notify Users
  #
  # @rest_param Id [Integer] The Id of Comm that need to be notified
  #
  # @rest_return Response [Object] Response Object with status 200
  # @rest_return error_message [String] A message returned when Comm notifying fails
  def call
    after_check do
      service_name = ApplicationController::SERVICE_NAME + (context[:current_user].service_name || '')
      result = RestClient.post(
        SystemConfig.get('ecx/host') + '/notify_users',
        { comm_id: context['id'], ECX_API: SystemConfig.get('ecx/api_key'), service_name: service_name }
      )
    rescue RestClient::Exception => e
      puts e.message, e.response
      Sentry.capture_exception(e)
      context.fail!(message: 'comms.notify_ecx_users')
    end
  end

  # Checks for comms Id prior to comms notifying call
  #
  # @return [Object,nil] Returns an Error Object if check fails else nil
  def check_context
    context.fail!(message: 'comms.missing_identifier') if context[:id].nil?
  end
end
