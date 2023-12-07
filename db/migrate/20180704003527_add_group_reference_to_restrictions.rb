class AddGroupReferenceToRestrictions < ActiveRecord::Migration[5.1]
  def up
    add_reference :restrictions, :group, foreign_key: true

    Restriction.all.each do |restriction|
      result = Groups::GetGroup.call(group_id: restriction.edo_id, columns: %w(id name))

      if result.success?
        group = Group.new(group_id: restriction.edo_id, group_type: (result.group[:name] == 'TSBE') ? 'edo' : 'non_edo')
        if group.save!
          group.reload
          restriction.group_id = group.id
          restriction.save!
        end
      end
    end

    remove_column :restrictions, :edo_id, :integer

  end

  def down
    add_column :restrictions, :edo_id, :integer

    Restriction.all.each do |restriction|
      restriction.edo_id = restriction.group.group_id
      restriction.group_id = nil
      restriction.save!

      Group.find_by(group_id: restriction.edo_id).destroy!
    end

    remove_reference :restrictions, :group, foreign_key: true
  end
end
