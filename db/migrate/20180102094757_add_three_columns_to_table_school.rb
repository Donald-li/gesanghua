class AddThreeColumnsToTableSchool < ActiveRecord::Migration[5.1]
  def change
    add_column :schools, :level, :integer, comment: '学校等级： 1:初中 2:高中'
    add_column :schools, :contact_name, :string, comment: '联系人'
    add_column :schools, :contact_phone, :string, comment: '联系方式'
  end
end
