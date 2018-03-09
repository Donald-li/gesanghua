class AddSchoolNoAndUserIdToTableSchools < ActiveRecord::Migration[5.1]
  def change
    add_column :schools, :user_id, :integer, comment: '校长ID'
    add_column :schools, :school_no, :string, comment: '学校申请编号'
    add_column :schools, :contact_idcard, :string, comment: '联系人身份证号'
    add_column :schools, :postcode, :string, comment: '邮政编码'
    add_column :schools, :teacher_count, :integer, comment: '教师人数'
    add_column :schools, :logistic_count, :integer, comment: '后勤人数'
    add_column :schools, :contact_telephone, :string, comment: '联系人座机号码'
  end
end
