class AddColumnsToTeachers < ActiveRecord::Migration[5.1]
  def change
    add_column :teachers, :idcard, :string, comment: '身份证'
    add_column :teachers, :qq, :string, comment: 'QQ'
    add_column :teachers, :openid, :string, comment: '微信openid'
  end
end
