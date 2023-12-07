require 'rest-client'
# The Class used for updating existing  Comm for corresponding User of EDO
#
# @rest_return Comm [Object] Comm Object after updation with details
# @rest_return error_message [String] A message returned when Comm updation failed
class Comms::UpdateComm
  include ExtendedInteractor

  # Call method used for updating the Comm associated with the User provided
  # Calls Comms Service to update Comm
  #
  # @rest_param Id [Integer] The Id of Comm that need to be updated
  # @rest_param params [Object] The parameters that need to be updated for Comm
  # @rest_param current_user [User] The User whose comms need to be updated
  #
  # @rest_return Comm [Object] Comm Object after updation with details
  # @rest_return error_message [String] A message returned when Comm updation fails
  def call
    after_check do
      user = { id: context[:current_user][:id], name: context[:current_user][:name],
               email: context[:current_user][:email] }
      service_name = ApplicationController::SERVICE_NAME + (context[:current_user].service_name || '')
      begin
        response = RestClient.put(
          SystemConfig.get('comm/host') + "/comms/#{context[:id]}",
          {
            comm: { id: context[:id],
                    recipients: JSON.parse(context[:params][:recipients].to_json),
                    sender: user,
                    comm_type: context[:params][:comm_type],
                    form_data: context[:params][:form_data].to_unsafe_h,
                    created_from: service_name,
                    service_name: service_name }
          }
        )
        context[:comm] = JSON.parse(response, symbolize_names: true)[:comm] if response.code == 200
      rescue RestClient::Exception => e
        puts e.message, e.response
        Sentry.capture_exception(e)
        context.fail!(message: 'comms.update_error')
      end
    end
  end

  # Checks for comms Id,params and current user prior to comms updation
  #
  # @return [Object,nil] Returns an Error Object if check fails else nil
  def check_context
    if context[:id].nil?
      context.fail!(message: 'comms.missing_identifier')
    elsif context[:params].nil?
      context.fail!(message: 'comms.missing_params')
    elsif context[:current_user].nil?
      context.fail!(message: 'comms.user_not_provided')
    end
  end
end
