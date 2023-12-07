require 'rest-client'
# The Class used for sending  Comm to recipients selected
#
# @rest_return Comm [Object] Comm Object after sending to recipients with details
# @rest_return error_message [String] A message returned when Comm sending comm failed
class Comms::SendComm
  include ExtendedInteractor

  # Call method used for sending the Comm associated with the recipients provided
  # Calls Comms Service to update Comm
  # After success Comm sent,notifies users about the comm
  #
  # @rest_param Id [Integer] The Id of Comm that need to be sent
  # @rest_param params [Object] The parameters that need to be sent with Comm
  # @rest_param current_user [User] The User whose comms need to be sent
  #
  # @rest_return Comm [Object] Comm Object after sending with details
  # @rest_return error_message [String] A message returned when Comm sending fails
  def call
    after_check do
      user = { id: context[:current_user][:id], name: context[:current_user][:name],
               email: context[:current_user][:email] }
      service_name = ApplicationController::SERVICE_NAME + (context[:current_user].service_name || '')
      begin
        response = RestClient.post(
          SystemConfig.get('comm/host') + '/send_comm',
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
        if response.code == 200
          context[:comm] = JSON.parse(response, symbolize_names: true)[:comm]

          if context[:comm][:user_recipients] && context[:comm][:user_recipients].length > 0
            user_ids = context[:comm][:user_recipients].map { |r| r[:sent_to_id] }
            users = User.where(id: user_ids)
            users.each do |user|
              if user.verified? && user.active?
                UsersMailer.send_notice(user, context[:comm][:comm_type], context[:current_user]).deliver_later!
              end
            end
          end

          notify_users

        end
      rescue RestClient::Exception => e
        puts e.message, e.response
        Sentry.capture_exception(e)
        context.fail!(message: 'comms.send_error')
      end
    end
  end

  # Notify_users method used for notifying to business users regarding the Comm associated
  # Calls NotifyUsers interactor to notify
  #
  # @rest_param context [Object] The context object with Comm
  #
  # @rest_return Response [Object] Response Object after status 200
  # @rest_return error_message [String] A message returned when Comm notifying fails
  def notify_users
    notify_result = Comms::NotifyUsers.call(id: context[:comm][:id], current_user: context[:current_user])

    context.fail!(message: notify_result.message) unless notify_result.success?
  end

  # Checks for comms Id,params and current user prior to comms send call
  #
  # @return [Object,nil] Returns an Error Object if check fails else nil
  def check_context
    if context[:params].nil?
      context.fail!(message: 'comms.missing_params')
    elsif context[:current_user].nil?
      context.fail!(message: 'comms.user_not_provided')
    end
  end
end
