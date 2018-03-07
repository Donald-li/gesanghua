class AddColumnKindToTableTeam < ActiveRecord::Migration[5.1]
  def change
    add_column :teams, :kind, :integer, comment: '分类：社会（society）高校（college）'
    add_column :teams, :province, :string, comment: '省'
    add_column :teams, :city, :string, comment: '市'
    add_column :teams, :district, :string, comment: '区县'
    add_column :teams, :address, :string, comment: '详细地址'
    add_column :teams, :describe, :text, comment: '简介'
    add_column :teams, :school_name, :string, comment: '高校名称'
    add_column :teams, :manage_id, :integer, comment: '负责人'

  end
end
