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
  let!(:promoter) { create(:user) }
  let!(:school) { create(:school, user: user) }
  let!(:teacher) { create(:teacher, school: school, user: user) }
  let!(:project) { create(:project, fund:Project.pair_project.fund, appoint_fund: Project.pair_project.appoint_fund) }
  let!(:season) { create(:project_season, project: project) }
  let!(:apply) { create(:project_season_apply, project: project, season: season, teacher: teacher, school: school) }
  let!(:child) { create(:project_season_apply_child, project: project, season: season, apply: apply, school: school, semester: 'next_term') }

  it '测试用户捐一对一的指定' do
    child.approve_pass
    gsh_child = child.gsh_child
    project = Project.pair_project
    DonateRecord.donate_child(user, gsh_child, 2)

    donate = DonateRecord.last
    expect(donate.user.id).to eq user.id
    expect(donate.project.id).to eq project.id
    expect(donate.unpay?).to be true
    expect(donate.amount).to eq donate.gsh_child.semesters.succeed.sum(:amount)
    expect(donate.promoter).to eq nil
    expect(donate.fund_id).to eq project.appoint_fund.id
    expect(donate.gsh_child.id).to eq gsh_child.id
    expect(donate.gsh_child.semesters.succeed.count).to eq 2
  end

<<<<<<< HEAD
=======
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

>>>>>>> cd5d969e29489a2989eb64de1bb17b306e67f7af
end
