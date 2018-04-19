class AddColumnNameToVolunteers < ActiveRecord::Migration[5.1]
  def change
    add_column :volunteers, :name, :string, comment: '志愿者真实姓名'
    add_column :volunteers, :id_card, :string, comment: '志愿者身份证'
  end
end
