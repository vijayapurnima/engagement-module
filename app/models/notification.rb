class Notification < ApplicationRecord
  belongs_to :notified_by, class_name: 'User', optional: true
  belongs_to :group

  scope :un_notified, -> { where(notified_at: nil, notified_by: nil, comm_id: nil) }
  scope :notified, -> { where.not(notified_at: nil, notified_by: nil, comm_id: nil) }

  UPDATE_PARAMS = %w[notified_by_id comm_id]

  after_create :clear_cache
  after_save :clear_cache

  def validate_notification_data
    errors[:base] << 'Notification ID is required' if notification_id.blank?
    errors[:base] << 'Notification Type is required' if notification_type.blank?
    errors[:base] << 'Group ID is required' if group_id.blank?
    errors[:base] << 'Notified at is required' if !new_record? && notified_at.blank?
    errors[:base] << 'Notified by ID is required' if !new_record? && notified_by_id.blank?
    errors[:base] << 'Comm ID is required' if !new_record? && comm_id.blank?

    errors[:base].length > 0 ? (raise ActiveRecord::RecordInvalid, self) : true
  end

  def notified_user
    return User.find(notified_by_id) unless notified_by_id.nil?
  end

  def get_notification_details(notification_type)
    if notification_id && self.notification_type == notification_type
      case notification_type
      when 'MarketRequest'
        result = Rails.cache.fetch(
          "presentation/models/notification/get_notification_details/market_request/#{notification_id}", expires_in: 1.seconds
        ) do
          MarketRequests::GetMarketRequest.call(id: notification_id, without_elements: true)
        end
        result.market_request if result.success?
      end
    end
  end

  def get_comm_details(current_user)
    unless comm_id.nil?
      result = Rails.cache.fetch("presentation/models/notification/get_comm_details/comms/#{comm_id}",
                                 expires_in: 12.hours) do
        Comms::GetComm.call(id: comm_id, current_user: current_user)
      end
      if result.success?
        unless result.comm[:user_recipients].nil?
          result.comm[:user_recipients].each do |user_rec|
            user = User.find(user_rec[:sent_to_id])
            unless user.nil?
              user_rec[:name] = user.name
              user_rec[:email] = user.email

            end
          end
        end
        result.comm
      end
    end
  end

  private

  def clear_cache
    Rails.cache.delete("presentation/models/notification/get_notification_details/MarketRequest/#{notification_id}")
    Rails.cache.delete("presentation/controllers/notifications/un_notified/MarketRequest/#{group_id}")
    Rails.cache.delete("presentation/controllers/notifications/notified/MarketRequest/#{group_id}")
    Rails.cache.delete("presentation/controllers/notifications/all/MarketRequest/#{group_id}")
    Rails.cache.delete("presentation/models/notification/get_comm_details/comms/#{comm_id}")
    Rails.cache.delete("presentation/controller/notifications/get_notification/#{id}")
  end
end
