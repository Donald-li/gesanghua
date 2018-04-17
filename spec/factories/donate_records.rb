# == Schema Information
#
# Table name: donate_records # 捐赠记录
#
#  id                            :integer          not null, primary key
#  donor_id                      :integer                                # 用户id
#  fund_id                       :integer                                # 基金ID
#  amount                        :decimal(14, 2)   default(0.0)          # 捐助金额
#  project_id                    :integer                                # 项目id
#  team_id                       :integer                                # 小组id
#  promoter_id                   :integer                                # 劝捐人
#  agent_id                      :integer                                # 汇款人id
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  project_season_id             :integer                                # 年度ID
#  project_season_apply_id       :integer                                # 年度项目ID
#  gsh_child_id                  :integer                                # 格桑花孩子id
#  income_record_id              :integer                                # 收入记录
#  title                         :string                                 # 捐赠标题
#  source_type                   :string
#  source_id                     :integer                                # 资金来源
#  owner_type                    :string
#  owner_id                      :integer                                # 捐助所属捐助项
#  donation_id                   :integer                                # 捐助id
#  kind                          :integer                                # 捐助方式 1:捐款 2:配捐
#  project_season_apply_child_id :integer                                # 一对一孩子
#

FactoryBot.define do
  factory :donate_record do
    amount {Faker::Number.decimal(2)}
    source {create(:user)}
    owner {create(:donate_item)}
    donor {Faker::Name.name}
  end
end
