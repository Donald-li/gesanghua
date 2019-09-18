class AddColumnIpToSmsCodes < ActiveRecord::Migration[5.1]
  def change
    add_column :sms_codes, :ip, :string
  end
end
