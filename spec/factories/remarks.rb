# == Schema Information
#
# Table name: remarks # 备注信息表
#
#  id            :bigint(8)        not null, primary key
#  content       :text                                   # 内容
#  owner_type    :string
#  owner_id      :integer
#  operator_type :string                                 # 操作类型
#  operator_id   :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

FactoryBot.define do
  factory :remark do
    
  end
end
