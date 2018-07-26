# == Schema Information
#
# Table name: camp_document_finances # 拓展营预决算表
#
#  id                      :bigint(8)        not null, primary key
#  user_id                 :integer                                # 用户
#  item                    :string                                 # 项
#  budge                   :decimal(14, 2)   default(0.0)          # 预算
#  amount                  :decimal(14, 2)   default(0.0)          # 决算
#  remark                  :string                                 # 备注
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  project_season_apply_id :integer                                # 探索营申请id
#  camp_id                 :integer                                # 探索营id
#

FactoryBot.define do
  factory :camp_document_finance do
    project_id 1
    user_id 1
    item "MyString"
    budge "9.99"
    amount "9.99"
    remark "MyString"
  end
end
