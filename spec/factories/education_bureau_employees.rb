# == Schema Information
#
# Table name: education_bureau_employees # 教育局工作人员表
#
#  id                  :integer          not null, primary key
#  name                :string                                 # 姓名
#  phone               :string                                 # 联系方式
#  nickname            :string                                 # 昵称
#  kind                :integer          default("director")   # 类型，1：局长 2：员工
#  education_bureau_id :integer                                # 教育局id
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  user_id             :integer                                # 用户ID
#

FactoryBot.define do
  factory :education_bureau_employee do
    name "MyString"
    phone "MyString"
    nickname "MyString"
    kind 1
  end
end
