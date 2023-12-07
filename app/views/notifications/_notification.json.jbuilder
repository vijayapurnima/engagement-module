json.extract! notification,
              :id,
              :notification_type,
              :notified_at,
              :created_at
json.notified_by do
  json.partial! 'users/user', user: notification.notified_user unless notification.notified_by_id.nil?
end
json.context_details notification.get_notification_details(notification_type) unless notification.notification_id.nil?

json.comm notification.get_comm_details(current_user) unless notification.comm_id.nil?
