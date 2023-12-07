class CreateEdoMemberships < ActiveRecord::Migration[5.1]
  def change
    create_table :edo_memberships do |t|
      t.references :user, index: true, foreign_key: true
      t.integer :edo_id
      t.string :role
      t.integer :invited_by, index: true
      t.timestamps
    end
    add_foreign_key :edo_memberships, :users, column: :invited_by
  end
end
