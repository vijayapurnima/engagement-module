require 'rest-client'
# The Class used for deleting Notification corresponding to EDO and Notification Type
#
# @rest_return Response [Object] Response Object with status 200
# @rest_return error_message [String] A message returned when Notification deletion fails
class EdoNotifications::DeleteNotification
  include ExtendedInteractor

  # Call method used for deleting the Notification associated with the id provided
  # Removes the record from Notifications Table
  #
  # @rest_param id [Integer] The id of the Notification
  #
  # @rest_return Response [Object] Response Object with status 200
  # @rest_return error_message [String] A message returned when notification deletion fails
  def call
      notification=Notification.find(context[:id])
      notification.destroy!
  end


  # Checks for id prior to notification removal
  #
  # @return [Object,nil] Returns an Error Object if check fails else nil
  def check_context
    unless context[:id]
      context.fail!(message: 'notification.missing_identifier')
    end
  end
end
