class CreateRestrictions < ActiveRecord::Migration[5.1]
  def change
    create_table :restrictions do |t|
      t.integer :edo_id,  index: true
      t.string  :restriction_type
      t.string  :restrictions
      t.timestamps
    end
  end
end
