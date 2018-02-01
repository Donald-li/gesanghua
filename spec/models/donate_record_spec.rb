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
#

require 'rails_helper'

RSpec.describe DonateRecord, type: :model do
  let!(:user) { create(:user) }
  let!(:project) { create(:project, fund: Fund.pari_restricted) }

  it '测试捐助格桑花' do

    DonateRecord.donate_gsh(user: user, amount: 101.1)

    donate_record = DonateRecord.last

    expect(donate_record.unpay?).to be true
    expect(donate_record.amount).to eq 101.1
    expect(donate_record.promoter).to eq nil
    expect(donate_record.fund_id).to eq Fund.gsh.id
  end

  it '测试捐助一对一非指定' do
    DonateRecord.donate_project(user: user, amount: 89.0, project: project)

    donate_record = DonateRecord.last

    expect(donate_record.unpay?).to be true
    expect(donate_record.amount).to eq 89.0
    expect(donate_record.promoter).to eq nil
    expect(donate_record.fund).to eq Fund.pari_restricted
    expect(donate_record.project).to eq project
  end

  it '测试捐助一对一指定' do

  end

end
