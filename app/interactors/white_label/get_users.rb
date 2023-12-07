require 'rest-client'
# The Class used for getting Users from White-label
#
# @rest_return User [Array] Array of User Objects with details
# @rest_return error_message [String] A message returned when Users retrieval fails
class WhiteLabel::GetUsers
  include ExtendedInteractor

  # Call method used for retrieving the Users
  # Calls White-label Presentation Service to retrieve Users with details
  #
  # @rest_return User [Array] Array of User Objects with details
  # @rest_return error_message [String] A message returned when Users retrieval fails
  def call
    response = RestClient.get(
      SystemConfig.get('tsbe/host') + '/users'
    )
    context[:users] = JSON.parse(response, symbolize_names: true) if response.code == 200
  rescue RestClient::Exception => e
    puts e.message, e.response
    Sentry.capture_exception(e)
    context.fail!(message: 'Cannot get Users from White-label')
  end
end
