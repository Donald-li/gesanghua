# == Schema Information
#
# Table name: visits # 家访记录表
#
#  id                      :bigint(8)        not null, primary key
#  owner_id                :integer
#  owner_type              :string
#  content                 :text                                   # 内容
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  apply_child_id          :integer                                # 孩子申请ID
#  user_id                 :integer                                # 用户ID
#  investigador            :string                                 # 调查人员
#  escort                  :string                                 # 陪同人员
#  survey_time             :datetime                               # 调查时间
#  family_size             :integer                                # 家庭人数
#  family_basic            :string                                 # 家庭基本情况
#  basic_information       :text                                   # 基本情况
#  income_information      :text                                   # 收入情况
#  expenditure_information :text                                   # 支出情况
#  lodge                   :string                                 # 是否寄宿
#  lodge_cost              :decimal(14, 2)   default(0.0)          # 住宿费用
#  other_subsidize         :text                                   # 其他资助
#  prize_information       :text                                   # 获奖情况
#  study_information       :text                                   # 学习情况
#  tuition_fee             :decimal(14, 2)   default(0.0)          # 学杂费
#  sponsor_fee             :string                                 # 是否赞助生活费
#

FactoryBot.define do
  factory :visit do
    owner_id 1
    owner_type "MyString"
    content "MyText"
  end
end
