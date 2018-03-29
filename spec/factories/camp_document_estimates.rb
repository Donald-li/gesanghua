# == Schema Information
#
# Table name: camp_document_estimates # 拓展营概算表
#
#  id                      :integer          not null, primary key
#  user_id                 :integer                                # 用户
#  item                    :string                                 # 项
#  amount                  :decimal(14, 2)   default(0.0)          # 金额
#  remark                  :string                                 # 备注
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  project_season_apply_id :integer                                # 探索营申请id
#  camp_id                 :integer                                # 探索营id
#

FactoryBot.define do
  factory :camp_document_estimate do
    project_id 1
    user_id 1
    item "MyString"
    amount "9.99"
    remark "MyString"
  end
end
