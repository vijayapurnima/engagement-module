class CreateLeads < ActiveRecord::Migration[5.1]
  def change
    create_table :leads do |t|
      t.references :user, index: true, foreign_key: true
      t.string  :name
      t.string  :contact
      t.integer :phone
      t.string  :email, index: true
      t.string :comments
      t.timestamps
    end
  end
end
