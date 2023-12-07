class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :email,  index: true
      t.string :name
      t.boolean :verified
      t.string :code
      t.datetime :code_created_at
      t.string :status
      t.string :user_type
      t.timestamps
    end
  end
end
