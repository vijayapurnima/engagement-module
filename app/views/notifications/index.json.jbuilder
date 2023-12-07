json.array!(@notifications) do |notification|
  json.partial! 'notifications/notification', notification: notification,notification_type:@notification_type,current_user:@current_user
end