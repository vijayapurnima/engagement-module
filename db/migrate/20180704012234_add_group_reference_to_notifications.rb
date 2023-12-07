class AddGroupReferenceToNotifications < ActiveRecord::Migration[5.1]
  def up
    add_reference :notifications, :group, foreign_key: true

    Notification.all.each do |notification|
      notification.group_id = Group.find_by(group_id: notification.edo_id).id
      notification.save!
    end

    remove_column :notifications, :edo_id, :integer
  end

  def down
    add_column :notifications, :edo_id, :integer

    Notification.all.each do |notification|
      notification.edo_id = notification.group.group_id
      notification.save!
    end

    remove_reference :notifications, :group, foreign_key: true
  end
end
