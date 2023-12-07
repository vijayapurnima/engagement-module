class CreateNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :notifications do |t|
      t.integer :edo_id, index: true
      t.integer :notification_id
      t.string  :notification_type
      t.datetime :notified_at
      t.integer  :notified_by_id,index: true
      t.integer  :comm_id
      t.timestamps
    end
    add_index :notifications, [:notification_id, :notification_type]
    add_foreign_key :notifications, :users, column: :notified_by_id
  end
end
