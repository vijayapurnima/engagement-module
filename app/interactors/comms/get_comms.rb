require 'rest-client'
# The Class used for getting  all Comms for corresponding User of EDO
#
# @rest_return Comms [Array<Object>] Array of Comms Objects with details
# @rest_return error_message [String] A message returned when Comms retrieval failed
class Comms::GetComms
  include ExtendedInteractor
  # Call method used for retrieving the Comms associated with the User provided
  # Calls Comms Service to retrieve Comms data
  #
  # @rest_param which [String] The type of the Comms
  # @rest_param current_user [User] The User whose comms need to be retrieved
  #
  # @rest_return Comms [Array<Object>] Array of Comms  with details
  # @rest_return error_message [String] A message returned when Comms retrieval fails
  def call
    after_check do
      response = RestClient.get(
        SystemConfig.get('comm/host') + "/comms?which=#{context[:which]}&user_id=#{context[:current_user][:id]}&service_name=#{ApplicationController::SERVICE_NAME + (context[:current_user].service_name || '')}"
      )
      if response.code == 200
        context[:comms] = JSON.parse(response)
        context[:comms].each do |comm|
          comm['user_recipients'].each do |user_rec|
            user = User.find(user_rec['sent_to_id'])
            unless user.nil?
              user_rec['name'] = user.name
              user_rec['email'] = user.email
            end
          end
        end
      end
    rescue RestClient::Exception => e
      puts e.message, e.response
      Sentry.capture_exception(e)
      context.fail!(message: 'comms.get_error')
    end
  end

  # Checks for comms parameters and current user prior to comms retrieval
  #
  # @return [Object,nil] Returns an Error Object if check fails else nil
  def check_context
    if context[:which].nil?
      context.fail!(message: 'comms.missing_params')
    elsif context[:current_user].nil?
      context.fail!(message: 'comms.user_not_provided')
    end
  end
end
