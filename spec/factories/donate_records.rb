# == Schema Information
#
# Table name: donate_records # 捐赠记录
#
#  id                                :integer          not null, primary key
#  user_id                           :integer                                # 用户id
#  appoint_type                      :string                                 # 指定类型
#  appoint_id                        :integer                                # 指定类型
#  fund_id                           :integer                                # 基金ID
#  pay_state                         :integer                                # 付款状态
#  amount                            :decimal(14, 2)   default(0.0)          # 捐助金额
#  project_id                        :integer                                # 项目id
#  team_id                           :integer                                # 小组id
#  message                           :string                                 # 留言
#  donor                             :string                                 # 捐赠者
#  promoter_id                       :integer                                # 劝捐人
#  remitter_name                     :string                                 # 汇款人姓名
#  remitter_id                       :integer                                # 汇款人id
#  voucher_state                     :integer                                # 捐赠收据状态
#  created_at                        :datetime         not null
#  updated_at                        :datetime         not null
#  project_season_id                 :integer                                # 年度ID
#  project_season_apply_id           :integer                                # 年度项目ID
#  project_season_apply_child_id     :integer                                # 年度孩子申请ID
#  donate_no                         :string                                 # 捐赠编号
#  voucher_id                        :integer                                # 捐助记录ID
#  period                            :integer                                # 月捐期数
#  month_donate_id                   :integer                                # 月捐id
#  certificate_no                    :string                                 # 捐赠证书编号
#  gsh_child_id                      :integer                                # 格桑花孩子id
#  kind                              :integer                                # 记录类型: 1:系统生成 2:手动添加
#  project_season_apply_bookshelf_id :integer                                # 书架id
#  bookshelf_supplement_id           :integer                                # 补书ID
#  donate_item_id                    :integer                                # 可捐助id
#  income_record_id                  :integer                                # 收入记录
#

FactoryBot.define do
  factory :donate_record do
    pay_state 'paid'
    amount {Faker::Number.decimal(2)}
    message {Faker::Lorem.sentences}
    donor {Faker::Name.name}
    remitter_name {Faker::Name.name}
    voucher_state 'to_bill'
    donate_no {Faker::Number.number(10)}
  end
end
