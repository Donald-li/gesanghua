class AddFourColumnsToVolunteers < ActiveRecord::Migration[5.1]
  def change
    add_column :volunteers, :province, :string, comment: '省'
    add_column :volunteers, :city, :string, comment: '市'
    add_column :volunteers, :district, :string, comment: '区县'
    add_column :volunteers, :address, :string, comment: '详细地址'
  end
end
