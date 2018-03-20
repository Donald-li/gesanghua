class AddColumnDescribeToVolunteer < ActiveRecord::Migration[5.1]
  def change
    add_column :volunteers, :describe, :text, comment: '个人简介'
    add_column :volunteers, :phone, :string, comment: '手机号'
    add_column :volunteers, :workstation, :string, comment: '工作单位'
  end
end
