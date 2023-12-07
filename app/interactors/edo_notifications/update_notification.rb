require 'rest-client'
# The Class used for getting updating Notification for corresponding EDO and Notification Type
#
# @rest_return Notification [Object] Notification Object with details
# @rest_return error_message [String] A message returned when Notification updation failed
class EdoNotifications::UpdateNotification
  include ExtendedInteractor

  # Call method used for updating the Notification associated with the EDO and Notification Type provided
  # updates a existing record in Notifications Table with params provided
  #
  # @rest_param params [Object] The parameters used for Notification creation
  #
  # @rest_return Notification [Object] Notification Object  with details
  # @rest_return error_message [String] A message returned when Notification updation fails
  def call
    after_check do
      notification=Notification.find(context[:id])
      params = context[:params].select {|p, v| Notification::UPDATE_PARAMS.include? p}
      notification.assign_attributes(params)
      notification.notified_at=Time.now
      notification.save! if notification.validate_notification_data
      context[:notification]=notification
    end
  end

  # Checks for notification params prior to notification updation
  #
  # @return [Object,nil] Returns an Error Object if check fails else nil
  def check_context
    if context[:id].nil?
      context.fail!(message: 'notification.missing_identifier')
    elsif Notification.find(context[:id]).group_id!=context[:current_user].group.id
      context.fail!(message: 'notification.edo_mismatch')
    end
    end
  end
