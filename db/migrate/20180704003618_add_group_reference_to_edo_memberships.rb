class AddGroupReferenceToEdoMemberships < ActiveRecord::Migration[5.1]
  def up
    add_reference :edo_memberships, :group, foreign_key: true

    EdoMembership.all.each do |member|
      member.group_id = Group.find_by(group_id: member.edo_id).id
      member.save!
    end

    remove_column :edo_memberships, :edo_id, :integer
  end

  def down
    add_column :edo_memberships, :edo_id, :integer

    EdoMembership.all.each do |member|
      member.edo_id = member.group.group_id
      member.save!
    end

    remove_reference :edo_memberships, :group, foreign_key: true
  end
end
