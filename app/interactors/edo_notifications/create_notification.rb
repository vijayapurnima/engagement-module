# The Class used for getting Creating Notification for corresponding EDO and Notification Type
#
# @rest_return Notification [Object] Notification Object with details
# @rest_return error_message [String] A message returned when Notification creation failed
class EdoNotifications::CreateNotification
  include ExtendedInteractor

  # Call method used for creating the Notification associated with the EDO and Notification Type provided
  # Creates a new record in Notifications Table with params provided
  #
  # @rest_param params [Object] The parameters used for Notification creation
  #
  # @rest_return Notification [Object] Notification Object  with details
  # @rest_return error_message [String] A message returned when Notification creation fails
  def call
    after_check do
      group = Group.find_by(group_id: context[:group_id])

      if Notification.exists?(notification_id: context[:notification_id], notification_type: context[:notification_type], group: group)
        context.fail!(message: 'notification.duplicate')
      else
        notification=Notification.new(notification_id:context[:notification_id],notification_type:context[:notification_type],group:group)
        notification.save! if notification.validate_notification_data
        context[:notification]=notification
      end

    end
  end

  # Checks for notification params prior to notification creation
  #
  # @return [Object,nil] Returns an Error Object if check fails else nil
  def check_context
    if context[:group_id].nil? || !Group.exists?(group_id: context[:group_id]) || context[:notification_id].nil? || context[:notification_type].nil?
      context.fail!(message: 'notification.missing_params')
    end
  end
end
