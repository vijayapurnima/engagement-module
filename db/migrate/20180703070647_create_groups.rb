class CreateGroups < ActiveRecord::Migration[5.1]
  def change
    create_table :groups do |t|
      t.integer :group_id
      t.string :group_type
      t.timestamps
    end
  end
end
