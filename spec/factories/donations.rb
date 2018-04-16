# == Schema Information
#
# Table name: donations # 捐助表
#
#  id                      :integer          not null, primary key
#  donor_id                :integer                                # 捐助人id
#  owner_type              :string
#  owner_id                :integer                                # 捐助所属模型
#  pay_state               :integer                                # 支付状态
#  voucher_state           :integer                                # 捐赠收据状态
#  project_id              :integer                                # 项目id
#  project_season_id       :integer                                # 批次/年度id
#  project_season_apply_id :integer                                # 申请id
#  order_no                :string                                 # 订单编号
#  certificate_no          :string                                 # 捐赠证书编号
#  title                   :string                                 # 标题
#  promoter_id             :integer                                # 劝捐人
#  team_id                 :integer                                # 团队id
#  pay_result              :text                                   # 支付接口返回的支付接口数据
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  details                 :jsonb                                  # 捐助详情
#  amount                  :decimal(14, 2)   default(0.0)          # 捐助金额
#  agent_id                :integer                                # 代理人id
#  voucher_id              :integer                                # 开票记录id
#

FactoryBot.define do
  factory :donation do
    donor {create :user}
    title '捐款说明'
    amount 1000
    owner { create(:donate_item)}


    trait :with_agent do
      agent { create :user }
    end

    trait :with_promoter do
      promoter { create :user }
    end

    trait :with_team do
      team
    end
  end
end
