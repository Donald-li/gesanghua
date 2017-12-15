# == Schema Information
#
# Table name: read_project_apply_items # 悦读类项目申请条目表
#
#  id         :integer          not null, primary key
#  name       :string                                 # 名称
#  number     :integer                                # 数量
#  balance    :decimal(14, 2)   default(0.0)          # 余额
#  title      :string                                 # 冠名
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :read_project_apply_item do
    name "MyString"
    number 1
    balance "9.99"
    title "MyString"
  end
end
