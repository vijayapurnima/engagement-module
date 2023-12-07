class ChangePhoneNumberToStringOnLeads < ActiveRecord::Migration[5.1]
  def up
    change_column :leads, :phone, :string
  end

  def down
    change_column :leads, :phone, 'integer USING CAST(phone AS integer)'
  end
end
