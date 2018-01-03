# == Schema Information
#
# Table name: gsh_children # 格桑花孩子表
#
#  id         :integer          not null, primary key
#  school_id  :integer                                # 关联学校id
#  name       :string                                 # 孩子姓名
#  province   :string                                 # 省
#  city       :string                                 # 市
#  district   :string                                 # 区/县
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :gsh_child do
    
  end
end
